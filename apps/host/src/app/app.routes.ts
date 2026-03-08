import { Route } from '@angular/router';

export const appRoutes: Route[] = [
  {
    path: '',
    redirectTo: 'products',
    pathMatch: 'full',
  },
  {
    path: 'products',
    loadChildren: () => import('productsRemote/Routes').then(m => m.remoteRoutes)
  },
  {
    path: 'product/:id',
    loadChildren: () => import('productDetailRemote/Routes').then(m => m.remoteRoutes)
  },
  {
    path: '**',
    redirectTo: 'products',
  },
];
