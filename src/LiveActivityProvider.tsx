import React, { ReactNode, FC } from 'react';
import LiveActivityContext from './LiveActivityContext';
import { LiveActivityState, LiveActivityStyles, ActivityTokenReceivedEvent } from './index';
import { EventSubscription } from 'expo-modules-core';
import {startActivity, stopActivity, updateActivity, addActivityTokenListener } from './LiveActivity';

interface LiveActivityProviderProps {
    children: ReactNode;
}

const LiveActivityProvider: FC<LiveActivityProviderProps> = ({children}) => {
    const handleStartActivity = (state: LiveActivityState, styles?: LiveActivityStyles): string => {
        return startActivity(state, styles);
    };

    const handleStopActivity = (id: string, state: LiveActivityState): void => {
        stopActivity(id, state);
    };

    const handleUpdateActivity = (id: string, state: LiveActivityState): void => {
        updateActivity(id, state);
    };

    const handleAddActivityTokenListener = (listener: (event: ActivityTokenReceivedEvent) => void): EventSubscription => {
        return addActivityTokenListener(listener);
    };

    return (
        <LiveActivityContext.Provider value={{ startActivity: handleStartActivity, stopActivity: handleStopActivity, updateActivity: handleUpdateActivity, addActivityTokenListener: handleAddActivityTokenListener }}>
            {children}
        </LiveActivityContext.Provider>
    );
};

export default LiveActivityProvider;