import React from 'react';
import { EventSubscription } from 'expo-modules-core';
import { LiveActivityState, LiveActivityStyles, ActivityTokenReceivedEvent } from "./types"

export interface LiveActivityContextType {
    startActivity: (state: LiveActivityState, styles?: LiveActivityStyles) => string;
    stopActivity: (id: string, state: LiveActivityState) => void;
    updateActivity: (id: string, state: LiveActivityState) => void;
    addActivityTokenListener(listener: (event: ActivityTokenReceivedEvent) => void): EventSubscription
}

const defaultContext: LiveActivityContextType = {
    startActivity: () => { throw new Error("Context not provided."); },
    stopActivity: () => { throw new Error("Context not provided."); },
    updateActivity: () => { throw new Error("Context not provided."); },
    addActivityTokenListener: () => { throw new Error("Context not provided."); }
};

const LiveActivityContext = React.createContext<LiveActivityContextType>(defaultContext);

export default LiveActivityContext;