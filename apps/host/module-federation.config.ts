import { ModuleFederationConfig } from '@nx/module-federation';

const config: ModuleFederationConfig = {
  name: 'host',
  remotes: [
    ['productsRemote', 'https://nxstore-products.azurewebsites.net/remoteEntry.js'],
    ['productDetailRemote', 'https://nxstore-productdetail.azurewebsites.net/remoteEntry.js'],
  ],
};

export default config;
