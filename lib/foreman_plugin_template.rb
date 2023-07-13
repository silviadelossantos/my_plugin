require 'foreman_plugin_template/engine'
require 'aws-sdk-ec2'
require 'terminal-table'

module ForemanPluginTemplate
    class DiskManagement
    #class << self

        ########
        ##volumes
        def list_volumes()
                ec2 = Aws::EC2::Client.new()
            response = ec2.describe_volumes()

            rows = []
            response.volumes.each do |volume|
                name = volume.tags.find { |tag| tag.key == "Name" }&.value || ""
                age = ((Time.now - volume.create_time) / 86400).round(2)
                instance_id = volume.attachments.first.instance_id rescue ""
                rows << [name, volume.volume_id, age, volume.availability_zone,volume.volume_type, volume.size, volume.state, instance_id]
            end
            rows
        end

        def create_volume(name, description, availability_zone, instance_id, type, size_gb, snapshot = nil)
            ec2 = Aws::EC2::Client.new(region: availability_zone[0..-2])

            response = ec2.create_volume({
                availability_zone: availability_zone,
                volume_type: type, #default gp2
                size: size_gb,
                snapshot_id: snapshot,
                tag_specifications: [
                    {
                        resource_type: "volume", 
                        tags: [
                            { key: "name", value: name },
                            { key: "description", value: description }
                        ]
                    }
                ]
            })

            volume_id = response.volume_id

            puts "The EBS Volume with the ID #{volume_id} was successfully created"
            
            wait = ec2.wait_until(:volume_available, volume_ids: [volume_id])
            if wait
            puts "the volume is available" 
            response.volume_id
            end  
        end


        def show_volume_info (volume_id)
            ec2 = Aws::EC2::Client.new()
            response = ec2.describe_volumes(volume_ids: [volume_id])

            volume_info = response.volumes[0]

            az=volume_info.availability_zone
            status = volume_info.state
            size = volume_info.size
            type = volume_info.volume_type
            iops = volume_info.iops
            if volume_info.attachments.any? 
                attach_status = volume_info.attachments[0].state
                instance_id = volume_info.attachments[0].instance_id
                device = volume_info.attachments[0].device
            end
            created_from = volume_info.snapshot_id

            return {
                az: az,
                status: status,
                size: size,
                type: type,
                iops: iops,
                attach_status: attach_status,
                instance_id: instance_id,
                device: device,
                created_from: created_from
            }
        end

        # def show_volume_attachments (region, volume_id)
        #     ec2 = Aws::EC2::Client.new(region: region)
        #     response = ec2.describe_volumes({
        #         volume_id: volume_id
        #     })
        #     #attachments = response.attachments.instance_id

        #     puts "volume attached to the instance with the ID #{attachments}"
        #     return  attachments
        # end

        def attach_volume (instance_id,volume_id,device)
            ec2 = Aws::EC2::Client.new()
            ec2.attach_volume({
                device: "/dev/xvdo",
                instance_id: instance_id,
                volume_id: volume_id
            }) 
            puts "volume attached to the instance with the ID #{instance_id}"
        end
        
        def detach_volume (volume_id)
            ec2 = Aws::EC2::Client.new()
            response = ec2.detach_volume({
                volume_id: volume_id,
                force: false
            }) 
            puts response.to_h
            puts "volume detached"
        end
        ########
        ##snapshots
        def list_snapshot(volume_id)
            ec2 = Aws::EC2::Client.new()
            response=ec2.describe_snapshots(filters: [{ name: 'volume-id', values: [volume_id] }])

            rows = []
            response.snapshots.each do |snapshot|
                name = snapshot.tags.find { |tag| tag.key == "Name" }&.value || ""
                id = snapshot.snapshot_id
                start = snapshot.start_time
                progress = snapshot.progress 
                rows << [name, id, start, progress]
            end
            rows
        end

        def create_snapshot(volume_id, name, description)
            ec2 = Aws::EC2::Client.new()

            response = ec2.create_snapshot({
                description: description, 
                volume_id: volume_id,
                tag_specifications: [
                    {
                        resource_type: "snapshot", 
                        tags: [
                            {
                                key: "name",
                                value: name
                            },
                        ],
                    },
                ],
            })
            puts "snapshot created with the ID #{response.snapshot_id}"
            response.snapshot_id
        end

        def show_snapshot_info (snapshot_id)
            ec2 = Aws::EC2::Client.new()
            response = ec2.describe_snapshots(snapshot_ids:[snapshot_id])

            snapshot_info = response.snapshots[0]
            
            description = snapshot_info.description
            volume_id = snapshot_info.volume_id
            progress = snapshot_info.progress
            size = snapshot_info.size
            progress = snapshot_info.progress
            state= snapshot_info.state
            started= snapshot_info.start_time

            puts "#{description}, #{volume_id}, #{size}, #{progress}, #{state}, #{started}"
            return {
                description: description,
                volume_id: volume_id,
                progress: progress,
                size: size,
                state: state,
                started: started
            }
        end

        def delete_snapshot(snapshot_id)
            ec2 = Aws::EC2::Client.new()
            response = ec2.delete_snapshot({
                snapshot_id: snapshot_id
              })
              puts "snapshot deleted"
        end

        def list_servers()
            ec2 = Aws::EC2::Client.new()
            response = ec2.describe_instances()

            instances_list = []
           
            instances = response.reservations.map(&:instances).flatten
            instances.each do |instance|
                name_tag = instance.tags.find { |tag| tag.key == 'Name' }
                instance_id = instance.instance_id
                if !name_tag.blank?
                    instances_list << [name_tag&.value,instance_id]
                end
            end
            instances_list
        end
    end
end

