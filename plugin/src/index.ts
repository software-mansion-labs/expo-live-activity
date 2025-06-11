import { ConfigPlugin } from 'expo/config-plugins';

const withMyApiKey: ConfigPlugin = config => {
  console.log('my custom plugin');
  return config;
};

export default withMyApiKey;
