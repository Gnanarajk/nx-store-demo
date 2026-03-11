import { withModuleFederation } from '@nx/module-federation/angular';

const config = {
  name: 'productsRemote',
  exposes: {
    './Routes': 'apps/productsRemote/src/app/remote-entry/entry.routes.ts',
  },
};

export default withModuleFederation(config, { dts: false });
