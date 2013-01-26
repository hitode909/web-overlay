// plot click counts to links
// data is dummy
(function(){
    var config = {
        "url": "https://github.com/blog/1390-secrets-in-the-code",
        "overlays": [],
    };

    for (var i = 0; i < 50; i++) {
        config.overlays.push({
            "selector": ".sidebar .mini-post-list li:has(a):eq(" + i + ")",
            "label": Math.floor((9000 + Math.random()*2000) / (i + 1)) + " clicks",
            "type": "all",
        });
    }

    return config;
})()