import { withModuleFederation } from '@nx/module-federation/angular';
import { BundleAnalyzerPlugin } from 'webpack-bundle-analyzer';
import config from './module-federation.config';

const plugins = [];

if (process.env['ANALYZE']) {
  plugins.push(new BundleAnalyzerPlugin({
    analyzerMode: 'static',
    reportFilename: 'bundle-report.html',
    openAnalyzer: true,
  }));
}

export default withModuleFederation(config, { dts: false, plugins });
