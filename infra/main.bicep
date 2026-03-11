@description('Azure region for resources')
param location string = 'westeurope'

@description('Environment name')
param env string = 'prod'

@description('Unique prefix for resources')
param prefix string = 'nxstore'

resource appServicePlan 'Microsoft.Web/serverfarms@2023-12-01' = {
  name: '${prefix}-${env}-asp'
  location: location
  sku: {
    name: 'B1'
    tier: 'Basic'
  }
}

resource hostApp 'Microsoft.Web/sites@2023-12-01' = {
  name: '${prefix}-host'
  location: location
  kind: 'web'
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    serverFarmId: appServicePlan.id
    httpsOnly: true
  }
}

resource productsApp 'Microsoft.Web/sites@2023-12-01' = {
  name: '${prefix}-products'
  location: location
  kind: 'web'
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    serverFarmId: appServicePlan.id
    httpsOnly: true
    siteConfig: {
      cors: {
        allowedOrigins: ['*']
      }
    }
  }
}

resource productDetailApp 'Microsoft.Web/sites@2023-12-01' = {
  name: '${prefix}-productdetail'
  location: location
  kind: 'web'
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    serverFarmId: appServicePlan.id
    httpsOnly: true
    siteConfig: {
      cors: {
        allowedOrigins: ['*']
      }
    }
  }
}

resource productDetailApp 'Microsoft.Web/sites@2023-12-01' = {
  name: '${prefix}-productdetail'
  location: location
  kind: 'web'
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    serverFarmId: appServicePlan.id
    httpsOnly: true
    siteConfig: {
      cors: {
        allowedOrigins: ['*']
      }
    }
  }
}

resource productDetailApp 'Microsoft.Web/sites@2023-12-01' = {
  name: '${prefix}-productdetail'
  location: location
  kind: 'web'
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    serverFarmId: appServicePlan.id
    httpsOnly: true
    siteConfig: {
      cors: {
        allowedOrigins: ['*']
      }
    }
  }
}

resource apiApp 'Microsoft.Web/sites@2023-12-01' = {
  name: '${prefix}-api'
  location: location
  kind: 'app'
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    serverFarmId: appServicePlan.id
    httpsOnly: true
  }
}

output hostUrl string = 'https://${hostApp.properties.defaultHostName}'
output productsUrl string = 'https://${productsApp.properties.defaultHostName}'
output productDetailUrl string = 'https://${productDetailApp.properties.defaultHostName}'
output apiUrl string = 'https://${apiApp.properties.defaultHostName}'
