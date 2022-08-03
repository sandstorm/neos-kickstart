import {sassPlugin} from 'esbuild-sass-plugin';
import esbuild from 'esbuild';

/**
 * This file contains the JS/CSS bundler configuration, as executed on `npm run build`
 */
esbuild.build({
    // Generic Options (shared between build.js and build-watch.js)
    entryPoints: ['./main.ts'],
    target: ['esnext'],
    bundle: true,
    sourcemap: true,
    outfile: '../Public/bundle.js',
    external: ['*.woff', '*.woff2'],
    plugins: [sassPlugin()],


    // Specific options for "npm run build"
    minify: true,
}).catch(() => process.exit(1))
