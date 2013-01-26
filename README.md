# WebOverlay

Annotate A Web Page and Take a Screenshot.

```
URL + Overlays(CSS Selectors + Labels) => Screenshot with annotation overlays
```

## When To Use

* To annotate webpage
* To find wrong markups
* To visualize access logs of website

## Usage

* Clone this repository.
* Write a config file.

```
$ git clone git://github.com/hitode909/web-overlay.git
$ cd web-overlay
$ ./bin/web-overlay.coffee examples/highlight-images.js a.png
```

* `a.png` will be generated on your working directory.

## Examples

### Highlight visible img elements on [Apple](http://apple.com)

![(result)](http://cdn-ak.f.st-hatena.com/images/fotolife/h/hitode909/20130127/20130127020407.png?1359219887)

https://github.com/hitode909/web-overlay/blob/master/examples/highlight-images.js

### Wrap articles that title contains 'Google' on [Hacker News](http://news.ycombinator.com)

![(result)](http://cdn-ak.f.st-hatena.com/images/fotolife/h/hitode909/20130127/20130127020409.png?1359219986)

https://github.com/hitode909/web-overlay/blob/master/examples/highlight-google-news.js

### Plot click counts to blog articles (data is dummy)

![(result)](http://cdn-ak.f.st-hatena.com/images/fotolife/h/hitode909/20130127/20130127020408.png?1359220012)

https://github.com/hitode909/web-overlay/blob/master/examples/click-count.js

To plot real data, You need to analyze your blog's access logs and create config file.

## Config File Format

Config file is a JSON or JavaScript file.

Below is an example.
This example highlights visible `img` elements on the website of Apple.

```javascript
{
    "url": "http://apple.com",
    "overlays": [
        {
            "selector": "img:visible",
            "label": "image",
            "type": "all"
        }
    ]
}
```

### url

The URL to take a screenshot.

### overlays

an array of `overlay`.
`overlay` consists of `selector`, `label` and `type`.

#### selector

The CSS Seletor to find elements for the overlay.
Matched elements are highlighted.
You can use [jQuery Selectors](http://api.jquery.com/category/selectors/).

#### label

The text to display on matched elements.

#### type

enumerated string `["all", "wrap"]`

* `"all"`: each matched elements are overlayed separately.
* `"wrap"`: all matched elements are grouped and overlayed by a big overlay.

## Requirement

* [PhantomJS](http://phantomjs.org/) (maybe >= 1.8)
