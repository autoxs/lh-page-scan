import { Builder, By, until } from 'selenium-webdriver';
import chrome from 'selenium-webdriver/chrome.js';
import lighthouse from 'lighthouse';
import { writeFile } from 'fs/promises';
import assert from 'assert';
import oTestURL from '../data/urls.json' assert { type: 'json' };
async function runLighthouse(url, chromePort) {
    const lighthouseConfig = {
        extends: 'lighthouse:default',
        onlyCategories: ['performance'],
    };

    const result = await lighthouse(url, {
        port: chromePort,
        output: 'html',
        config: lighthouseConfig,
    });

    //html report
    const reportHtml = result.report;
    const reportName = `reports/lighthouse-report-${url.replace(/[^a-zA-Z0-9]/g, '_')}.html`;
    await writeFile(reportName, reportHtml);
    console.log(`Lighthouse report saved as ${reportName}`);

    
}


async function runTest(urls) {
    const chromeOptions = new chrome.Options();
    chromeOptions.addArguments('--headless');

    const driver = await new Builder()
        .forBrowser('chrome')
        .setChromeOptions(chromeOptions)
        .build();

    const chromeLauncher = await import('chrome-launcher');
    const chromeInstance = await chromeLauncher.launch({ chromeFlags: ['--incognito'] });
    const chromePort = chromeInstance.port;

    try {
        for (const url of urls) {
            console.log(`Navigating to ${url}`);
            await driver.get(url);
            await driver.sleep(2000); 
            const currentUrl = await driver.getCurrentUrl();

            assert.ok(currentUrl, 'URL does not exist');
            
            await runLighthouse(currentUrl, chromePort);
        }
    } finally {
        await driver.quit();
        await chromeInstance.kill();
    }
}

const urlSets = ['https://example.com','https://www.google.com'];

//commant above line and uncomment below line in case want to use json file to get urls.
//const urlSets = oTestURL.urlsToTest;

(async () => {
    console.log(`Running audits for the following URLs: ${urlSets}`);
    await runTest(urlSets);
    console.log('All tests and Lighthouse audits completed');
})().catch(err => console.error('Error:', err));
