import { Route } from '@angular/router';

export const remoteRoutes: Route[] = [
  {
    path: '',
    loadChildren: () =>
      import('@org/shop/feature-product-detail').then(m => m.featureProductDetailRoutes)
  }
];