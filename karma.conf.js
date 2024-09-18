const process = require('process');
const puppeteer = require('puppeteer');

// Set the Chrome binary path from Puppeteer
process.env.CHROME_BIN = puppeteer.executablePath();

module.exports = function(config) {
    config.set({
        // Use the HeadlessChrome launcher
        browsers: ['HeadlessChrome'],
        customLaunchers: {
            HeadlessChrome: {
                base: 'ChromeHeadless',
                flags: [
                    '--no-sandbox',
                    '--disable-gpu',
                    '--disable-dev-shm-usage', // Overcomes limited resource problems
                    '--headless'
                ]
            }
        },
        // Other configurations like files, frameworks, preprocessors, etc.
        // files: [
        //     // Your test files go here
        // ],
        frameworks: ['jasmine', 'karma-typescript'], // Example frameworks
        reporters: ['progress', 'karma-junit-reporter'], // Example reporters
        // Add your Karma options as needed
    });
};
