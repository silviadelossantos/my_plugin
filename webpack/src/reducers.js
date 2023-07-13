import { combineReducers } from 'redux';
import EmptyStateReducer from './Components/EmptyState/EmptyStateReducer';

const reducers = {
  foremanDiskManagement: combineReducers({
    emptyState: EmptyStateReducer,
  }),
};

export default reducers;
