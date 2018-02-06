/*require('zone.js/dist/zone')
import { platformBrowser } from '@angular/platform-browser'
import { enableProdMode } from '@angular/core'

import { AppModuleNgFactory } from './app/app.module.ngfactory'

enableProdMode()

platformBrowser().bootstrapModuleFactory(AppModuleNgFactory)*/


require('zone.js/dist/zone')
import { platformBrowserDynamic } from '@angular/platform-browser-dynamic'
import { enableProdMode } from '@angular/core'
import { AppModule } from './app.module'

enableProdMode()

platformBrowserDynamic().bootstrapModule(AppModule)