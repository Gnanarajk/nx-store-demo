import { Route } from '@angular/router';

export const remoteRoutes: Route[] = [
  {
    path: '',
    loadChildren: () =>
      import('@org/shop/feature-products').then(m => m.featureProductsRoutes)
  }
];