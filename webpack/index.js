import componentRegistry from 'foremanReact/components/componentRegistry';
import ExtendedEmptyState from './src/Components/EmptyState/ExtendedEmptyState';
import WelcomePage from './src/Router/WelcomePage/Welcome'
import DiskSwitcher from './src/Components/DiskSwitcher';

// register components for erb mounting
componentRegistry.register({
    name: 'ExtendedEmptyState',
    type: ExtendedEmptyState,
});
componentRegistry.registerMultiple([
  {
     name: 'DiskSwitcher',
     type: DiskSwitcher,
    }
  ]);


App();
function App(){
    const notify = () => toast("Wow so easy!");
    return (
      <div>
        <button onClick={notify}>Notify!</button>
        <ToastContainer />
      </div>
    ); 
}

