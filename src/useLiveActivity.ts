import { useContext } from 'react';
import LiveActivityContext from './LiveActivityContext';

const useLiveActivity = () => {
    const context = useContext(LiveActivityContext);

    if (!context) {
        throw new Error('useLiveActivity must be used within a LiveActivityProvider');
    }

    return context;
}

export default useLiveActivity;