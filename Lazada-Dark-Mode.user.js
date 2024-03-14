// ==UserScript==
// @name         Lazada.com Dark Mode
// @namespace    https://github.com/judigot/
// @version      0.3
// @description  Darken Lazada using plain old CSS
// @encoding     utf-8
// @homepage     https://github.com/judigot/references
// @supportURL   https://github.com/judigot/references/issues
// @updateURL    https://github.com/judigot/references/blob/main/Lazada-Dark-Mode.user.js
// @downloadURL  https://github.com/judigot/references/blob/main/Lazada-Dark-Mode.user.js
// @author       judigot
// @match        *.lazada.com.ph/*
// @grant        none
// @icon https://lzd-img-global.slatic.net/g/tps/tfs/TB1e_.JhHY1gK0jSZTEXXXDQVXa-64-64.png
// ==/UserScript==

(function() {
    'use strict';

    const style = document.createElement('style');
    style.type = 'text/css';
    style.innerHTML = `
        * {
            background-color: black !important;
            color: white !important;
            color: white !important;
        }
    `;
    document.head.appendChild(style);
})();
