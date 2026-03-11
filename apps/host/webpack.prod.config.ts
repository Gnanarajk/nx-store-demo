import { withModuleFederation } from '@nx/module-federation/angular';

export default withModuleFederation({
  name: 'host',
  remotes: [
    ['productsRemote', 'https://nxstore-products.azurewebsites.net/remoteEntry.mjs'],
    ['productDetailRemote', 'https://nxstore-productdetail.azurewebsites.net/remoteEntry.mjs'],
  ],
}, { dts: false });
