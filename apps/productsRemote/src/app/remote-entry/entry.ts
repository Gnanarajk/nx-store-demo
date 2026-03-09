import { Component, ViewEncapsulation } from '@angular/core';
import { NxWelcome } from './nx-welcome';

@Component({
  imports: [NxWelcome],
  selector: 'app-products-remote-entry',
  template: `<app-nx-welcome></app-nx-welcome>`,
  encapsulation: ViewEncapsulation.ShadowDom,
})
export class RemoteEntry {}
