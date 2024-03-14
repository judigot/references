// ==UserScript==
// @name         Lazada.com Force Official Dark Mode (M-FODM)
// @namespace    https://github.com/judigot/
// @version      0.3
// @description  Append the "__fb-dark-mode" class to the HTML tag and force Facebook's official Dark Mode
// @encoding     utf-8
// @homepage     https://github.com/judigot/references
// @supportURL   https://github.com/judigot/references/issues
// @updateURL    https://github.com/judigot/references/blob/main/Lazada-Dark-Mode.user.js
// @downloadURL  https://github.com/judigot/references/blob/main/Lazada-Dark-Mode.user.js
// @author       judigot
// @match        *.lazada.com/*
// @grant        none
// @icon https://lzd-img-global.slatic.net/g/tps/tfs/TB1e_.JhHY1gK0jSZTEXXXDQVXa-64-64.png
// ==/UserScript==

(function() {
    'use strict';

    document.querySelector('html').classList.remove('__fb-light-mode');
    document.querySelector('html').classList.add('__fb-dark-mode');

    function setDarkTheme() {
        document.querySelector('html').classList.remove('__fb-light-mode');
        document.querySelector('html').classList.add('__fb-dark-mode');
        document.querySelectorAll('.__fb-light-mode').forEach(elem => {
            elem.classList.remove('__fb-light-mode');
            elem.classList.add('__fb-dark-mode');
        });
    };

    // Select the node that will be observed for mutations
    const targetNode = document.getElementById("facebook");

    // Options for the observer (which mutations to observe)
    const config = { attributes: false, childList: true, subtree: true };

    // Callback function to execute when mutations are observed
    const callback = (mutationList, observer) => {
        for (const mutation of mutationList) {
            if (mutation.type === "childList") {
                setDarkTheme();
            }
        }
    };

    // Create an observer instance linked to the callback function
    const observer = new MutationObserver(callback);

    // Start observing the target node for configured mutations
    observer.observe(targetNode, config);

    // Reference to https://developer.mozilla.org/en-US/docs/Web/API/MutationObserver
})();
