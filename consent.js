/* Cookie consent for visitors in the EEA and the UK.
   GitHub Pages can't see a visitor's country, so the browser's time zone stands in for it:
   no third-party lookup, and the answer is known before any tracker loads. A zone we can't
   read counts as inside the region.
   Trackers sit in each page as <script type="text/plain" data-consent> and only run from
   here, so this file goes after them in <head>. A decline is respected in any time zone. */
(function () {
    var KEY = 'egbe_consent';
    var KEEP_FOR = 180 * 24 * 60 * 60 * 1000; // ask again after about six months
    var ZONES = [
        // EU, with its outermost regions
        'Africa/Ceuta', 'America/Cayenne', 'America/Guadeloupe', 'America/Marigot', 'America/Martinique',
        'Asia/Famagusta', 'Asia/Nicosia', 'Atlantic/Azores', 'Atlantic/Canary', 'Atlantic/Madeira', 'Eire',
        'Europe/Amsterdam', 'Europe/Athens', 'Europe/Berlin', 'Europe/Bratislava', 'Europe/Brussels',
        'Europe/Bucharest', 'Europe/Budapest', 'Europe/Busingen', 'Europe/Copenhagen', 'Europe/Dublin',
        'Europe/Helsinki', 'Europe/Lisbon', 'Europe/Ljubljana', 'Europe/Luxembourg', 'Europe/Madrid',
        'Europe/Malta', 'Europe/Mariehamn', 'Europe/Nicosia', 'Europe/Paris', 'Europe/Prague', 'Europe/Riga',
        'Europe/Rome', 'Europe/Sofia', 'Europe/Stockholm', 'Europe/Tallinn', 'Europe/Vienna', 'Europe/Vilnius',
        'Europe/Warsaw', 'Europe/Zagreb', 'Indian/Mayotte', 'Indian/Reunion', 'Poland', 'Portugal',
        // rest of the EEA
        'Arctic/Longyearbyen', 'Atlantic/Reykjavik', 'Europe/Oslo', 'Europe/Vaduz', 'Iceland',
        // UK, with the Crown Dependencies and Gibraltar
        'Europe/Belfast', 'Europe/Gibraltar', 'Europe/Guernsey', 'Europe/Isle_of_Man', 'Europe/Jersey',
        'Europe/London', 'GB', 'GB-Eire'
    ];
    var STYLES =
        '#egbe-consent { position: fixed; z-index: 1000; left: 16px; bottom: max(16px, env(safe-area-inset-bottom));' +
        ' width: 380px; max-width: calc(100vw - 32px); padding: 20px; border: 1px solid #E3E5EE; border-radius: 24px;' +
        ' background: #fff; color: #54566B; font: 400 0.9375rem/1.5 Figtree, "Helvetica Neue", Helvetica, Arial, sans-serif;' +
        ' box-shadow: 0 1px 2px rgba(27, 28, 46, 0.05), 0 26px 52px -26px rgba(27, 28, 46, 0.4); }' +
        '#egbe-consent, #egbe-consent * { box-sizing: border-box; }' +
        '#egbe-consent p { margin: 0; }' +
        '#egbe-consent a { color: #4153D4; }' +
        '#egbe-consent .choices { display: grid; grid-template-columns: 1fr 1fr; gap: 8px; margin-top: 16px; }' +
        '#egbe-consent button { min-height: 44px; padding: 0 16px; border: 0; border-radius: 999px; background: #ECEEFD;' +
        ' color: #4153D4; font: inherit; font-weight: 500; cursor: pointer; }' +
        '#egbe-consent button:hover { background: #5266EB; color: #fff; }' +
        '#egbe-consent :focus-visible { outline: 2px solid #5266EB; outline-offset: 3px; }';

    var running = false;

    function inRegion() {
        try {
            var zone = Intl.DateTimeFormat().resolvedOptions().timeZone;
            return !zone || ZONES.indexOf(zone) !== -1;
        } catch (e) {
            return true;
        }
    }

    function savedChoice() {
        try {
            var saved = JSON.parse(localStorage.getItem(KEY));
            return saved && Date.now() - saved.at < KEEP_FOR ? saved.choice : null;
        } catch (e) {
            return null;
        }
    }

    function saveChoice(choice) {
        try {
            localStorage.setItem(KEY, JSON.stringify({ choice: choice, at: Date.now() }));
        } catch (e) {}
    }

    // Scripts only execute when created by script, so each held tag is swapped for a live copy.
    function runTrackers() {
        running = true;
        document.querySelectorAll('script[type="text/plain"][data-consent]').forEach(function (held) {
            var script = document.createElement('script');
            Array.prototype.forEach.call(held.attributes, function (attr) {
                if (attr.name !== 'type' && attr.name !== 'data-consent') script.setAttribute(attr.name, attr.value);
            });
            script.async = held.hasAttribute('async');
            script.text = held.text;
            held.parentNode.replaceChild(script, held);
        });
    }

    function clearTraces() {
        try {
            localStorage.removeItem('egbe_vid');
        } catch (e) {}
        document.cookie.split('; ').forEach(function (pair) {
            var name = pair.split('=')[0];
            if (name.indexOf('_ga') !== 0) return;
            document.cookie = name + '=; Max-Age=0; path=/';
            document.cookie = name + '=; Max-Age=0; path=/; domain=.' + location.hostname;
        });
    }

    function choose(choice) {
        saveChoice(choice);
        if (choice === 'granted') {
            runTrackers();
            return;
        }
        clearTraces();
        if (running) location.reload(); // trackers already on this page can only stop with it
    }

    function showBanner(opener) {
        if (document.getElementById('egbe-consent')) return;
        if (!document.getElementById('egbe-consent-styles')) {
            var styles = document.createElement('style');
            styles.id = 'egbe-consent-styles';
            styles.textContent = STYLES;
            document.head.appendChild(styles);
        }
        var box = document.createElement('div');
        box.id = 'egbe-consent';
        box.setAttribute('role', 'dialog');
        box.setAttribute('aria-labelledby', 'egbe-consent-text');
        box.innerHTML =
            '<p id="egbe-consent-text">We use analytics and session recordings to improve this site. ' +
            '<a href="/privacy/">Privacy Policy</a></p>' +
            '<div class="choices">' +
            '<button type="button" data-choice="granted">Accept</button>' +
            '<button type="button" data-choice="denied">Decline</button>' +
            '</div>';
        box.addEventListener('click', function (event) {
            var choice = event.target.getAttribute('data-choice');
            if (!choice) return;
            box.remove();
            if (opener) opener.focus();
            choose(choice);
        });
        document.body.appendChild(box);
        if (opener) box.querySelector('button').focus();
    }

    function onPageReady() {
        document.querySelectorAll('[data-consent-settings]').forEach(function (link) {
            link.hidden = false;
        });
        if (!choice) showBanner();
    }

    var asked = inRegion();
    var choice = savedChoice();

    if (choice === 'granted' || (!asked && choice !== 'denied')) runTrackers();
    if (!asked && !choice) return;

    document.addEventListener('click', function (event) {
        var link = event.target.closest('[data-consent-settings]');
        if (!link) return;
        event.preventDefault();
        showBanner(link);
    });
    if (document.readyState === 'loading') document.addEventListener('DOMContentLoaded', onPageReady);
    else onPageReady();
})();
