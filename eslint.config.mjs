import nx from '@nx/eslint-plugin';

export default [
  ...nx.configs['flat/base'],
  ...nx.configs['flat/typescript'],
  ...nx.configs['flat/javascript'],
  {      "ignores": [
        "**/dist",
        "**/vite.config.*.timestamp*",
        "**/vitest.config.*.timestamp*"
      ]
  },
  {
    files: ['**/*.ts', '**/*.tsx', '**/*.js', '**/*.jsx'],
    rules: {
      '@nx/enforce-module-boundaries': [
        'error',
        {
          enforceBuildableLibDependency: true,
          allow: ['^.*/eslint(\\.base)?\\.config\\.[cm]?[jt]s$'],
          depConstraints: [
            {
              sourceTag: 'scope:shared',
              onlyDependOnLibsWithTags: ['scope:shared'],
            },
            {
              sourceTag: 'scope:host',
              onlyDependOnLibsWithTags: ['scope:host', 'scope:shared', 'scope:products', 'scope:productDetail', 'scope:data', 'scope:sharedUi', 'scope:shop'],
            },
            {
              sourceTag: 'scope:products',
              onlyDependOnLibsWithTags: ['scope:products', 'scope:shop', 'scope:shared'],
            },
            {
              sourceTag: 'scope:productDetail',
              onlyDependOnLibsWithTags: ['scope:productDetail', 'scope:shop', 'scope:shared'],
            },
            {
              sourceTag: 'scope:data',
              onlyDependOnLibsWithTags: ['scope:data', 'scope:api', 'scope:shared'],
            },
            {
              sourceTag: 'scope:sharedUi',
              onlyDependOnLibsWithTags: ['scope:sharedUi', 'scope:shared'],
            },
            {
              sourceTag: 'scope:shop',
              onlyDependOnLibsWithTags: ['scope:shop', 'scope:shared'],
            },
            {
              sourceTag: 'scope:api',
              onlyDependOnLibsWithTags: ['scope:api', 'scope:shared'],
            },
            {
              sourceTag: 'type:data',
              onlyDependOnLibsWithTags: ['type:data'],
            },
            {
              sourceTag: 'type:app',
              onlyDependOnLibsWithTags: ['scope:host', 'scope:shared', 'scope:products', 'scope:productDetail', 'scope:data', 'scope:sharedUi', 'scope:shop', 'scope:api', 'type:data', 'type:feature', 'type:ui'],
            },
          ],
        },
      ],
    },
  },
  {
    files: [
      '**/*.ts',
      '**/*.tsx',
      '**/*.cts',
      '**/*.mts',
      '**/*.js',
      '**/*.jsx',
      '**/*.cjs',
      '**/*.mjs',
    ],
    // Override or add rules here
    rules: {},
  },
];
