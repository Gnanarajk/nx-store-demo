import { withModuleFederation } from '@nx/module-federation/angular';

export default withModuleFederation({
  name: 'host',
  remotes: [
    ['productsRemote', 'https://nxstore-products.azurewebsites.net/remoteEntry.js'],
    ['productDetailRemote', 'https://nxstore-productdetail.azurewebsites.net/remoteEntry.js'],
  ],
}, { dts: false });
