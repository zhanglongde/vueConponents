<script>
'use strict';

Object.defineProperty(exports, "__esModule", {
    value: true
});
exports.default = {
    props: ['slide', 'pages'],
    ready: function ready() {
        var _this = this;

        this.$on('slideTo', function (num) {
            _this.turnTo(num);
        });

        this.$on('slideNext', function () {
            _this.next();
        });

        this.$on('slidePre', function () {
            _this.pre();
        });
    },

    methods: {
        swipeUp: function swipeUp(move) {
            this.$dispatch('swipeUp', move);
        },
        swipeDown: function swipeDown(move) {
            this.$dispatch('swipeDown', move);
        },
        reset: function reset() {
            var slideTmp = this.pages;
            var _iteratorNormalCompletion = true;
            var _didIteratorError = false;
            var _iteratorError = undefined;

            try {
                for (var _iterator = slideTmp[Symbol.iterator](), _step; !(_iteratorNormalCompletion = (_step = _iterator.next()).done); _iteratorNormalCompletion = true) {
                    var page = _step.value;

                    page.current = 0;
                    this.styleCompute(page);
                }
            } catch (err) {
                _didIteratorError = true;
                _iteratorError = err;
            } finally {
                try {
                    if (!_iteratorNormalCompletion && _iterator.return) {
                        _iterator.return();
                    }
                } finally {
                    if (_didIteratorError) {
                        throw _iteratorError;
                    }
                }
            }
        },
        checkState: function checkState() {
            this.slide.init.canNext = true;
            this.slide.init.canPre = true;

            var len = this.pages.length;
            if (this.pages[len - 2].origin + this.pages[len - 2].current == -100) {
                this.slide.init.canNext = false;
            }
            if (this.pages[1].origin + this.pages[1].current == 100) {
                this.slide.init.canPre = false;
            }
        },
        swipeStart: function swipeStart(e) {

            if (e.type === 'touchstart') {
                if (e.touches.length > 1) {
                    this.slide.init.tracking = false;
                    return;
                } else {
                    this.slide.init.tracking = true;
                    /* Hack - would normally use e.timeStamp but it's whack in Fx/Android */
                    this.slide.init.start.t = new Date().getTime();
                    this.slide.init.start.x = e.targetTouches[0].clientX;
                    this.slide.init.start.y = e.targetTouches[0].clientY;
                }
            } else {
                this.slide.init.tracking = true;
                /* Hack - would normally use e.timeStamp but it's whack in Fx/Android */
                this.slide.init.start.t = new Date().getTime();
                this.slide.init.start.x = e.clientX;
                this.slide.init.start.y = e.clientY;
            }
        },
        swipeMove: function swipeMove(e) {

            if (this.slide.init.tracking) {
                if (e.type === 'touchmove') {
                    e.preventDefault();
                    this.slide.init.end.x = e.targetTouches[0].clientX;
                    this.slide.init.end.y = e.targetTouches[0].clientY;
                } else {
                    e.preventDefault();
                    this.slide.init.end.x = e.clientX;
                    this.slide.init.end.y = e.clientY;
                }
            }
        },
        swipeEnd: function swipeEnd(e) {
            this.slide.init.tracking = false;
            var now = new Date().getTime();
            var deltaTime = now - this.slide.init.start.t;
            var deltaX = this.slide.init.end.x - this.slide.init.start.x;
            var deltaY = this.slide.init.end.y - this.slide.init.start.y;
            /* work out what the movement was */
            if (deltaTime > this.slide.init.thresholdTime) {
                /* gesture too slow */
                return;
            } else {
                if (deltaX > this.slide.init.thresholdDistance && Math.abs(deltaY) < this.slide.init.thresholdDistance) {
                    //swipe right
                    this.pre();
                } else if (-deltaX > this.slide.init.thresholdDistance && Math.abs(deltaY) < this.slide.init.thresholdDistance) {
                    //swipe left
                    this.next();
                } else if (deltaY > this.slide.init.thresholdDistance && Math.abs(deltaX) < this.slide.init.thresholdDistance) {
                    //swipe down
                    this.swipeDown(Math.abs(deltaY));
                } else if (-deltaY > this.slide.init.thresholdDistance && Math.abs(deltaX) < this.slide.init.thresholdDistance) {
                    //swipe up
                    this.swipeUp(Math.abs(deltaY));
                } else {
                    //nothing
                }
            }
        },
        pre: function pre() {
            if (!this.slide.init.canPre) return;

            var _iteratorNormalCompletion2 = true;
            var _didIteratorError2 = false;
            var _iteratorError2 = undefined;

            try {
                for (var _iterator2 = this.pages[Symbol.iterator](), _step2; !(_iteratorNormalCompletion2 = (_step2 = _iterator2.next()).done); _iteratorNormalCompletion2 = true) {
                    var page = _step2.value;

                    this.currentCompute(page, false);
                }
            } catch (err) {
                _didIteratorError2 = true;
                _iteratorError2 = err;
            } finally {
                try {
                    if (!_iteratorNormalCompletion2 && _iterator2.return) {
                        _iterator2.return();
                    }
                } finally {
                    if (_didIteratorError2) {
                        throw _iteratorError2;
                    }
                }
            }

            this.slide.init.currentPage--;
            this.checkState();
        },
        next: function next() {
            if (!this.slide.init.canNext) return;

            var _iteratorNormalCompletion3 = true;
            var _didIteratorError3 = false;
            var _iteratorError3 = undefined;

            try {
                for (var _iterator3 = this.pages[Symbol.iterator](), _step3; !(_iteratorNormalCompletion3 = (_step3 = _iterator3.next()).done); _iteratorNormalCompletion3 = true) {
                    var page = _step3.value;

                    this.currentCompute(page, true);
                }
            } catch (err) {
                _didIteratorError3 = true;
                _iteratorError3 = err;
            } finally {
                try {
                    if (!_iteratorNormalCompletion3 && _iterator3.return) {
                        _iterator3.return();
                    }
                } finally {
                    if (_didIteratorError3) {
                        throw _iteratorError3;
                    }
                }
            }

            this.slide.init.currentPage++;
            this.checkState();
        },
        turnTo: function turnTo(num) {
            var index = Math.ceil(num) - 1;
            var len = this.pages.length;
            var step = 0;
            if (index > this.pages.length - 1) {
                console.error("there are no more pages");
                return false;
            }
            this.slide.init.currentPage = Math.ceil(num);

            for (var i = 0; i < len; i++) {
                if (this.pages[i].current + this.pages[i].origin == 0) {
                    step = index - i;
                    break;
                }
            }

            var _iteratorNormalCompletion4 = true;
            var _didIteratorError4 = false;
            var _iteratorError4 = undefined;

            try {
                for (var _iterator4 = this.pages[Symbol.iterator](), _step4; !(_iteratorNormalCompletion4 = (_step4 = _iterator4.next()).done); _iteratorNormalCompletion4 = true) {
                    var page = _step4.value;

                    page.current = page.current - step * 100;
                    this.styleCompute(page);
                }
            } catch (err) {
                _didIteratorError4 = true;
                _iteratorError4 = err;
            } finally {
                try {
                    if (!_iteratorNormalCompletion4 && _iterator4.return) {
                        _iterator4.return();
                    }
                } finally {
                    if (_didIteratorError4) {
                        throw _iteratorError4;
                    }
                }
            }

            this.checkState();
        },
        currentCompute: function currentCompute(obj, next) {
            if (next) {
                obj.current = obj.current - 100;
            } else {
                obj.current = obj.current + 100;
            }
            this.styleCompute(obj);
        },
        styleCompute: function styleCompute(obj) {
            obj.style['transform'] = 'translateX(' + (obj.origin + obj.current) + '%)';
        }
    }
};
</script>
<style>
.slider {
    position: relative;
    height: 400px;
    top: 0;
    left: 0;
    color: #fff;
    overflow: hidden;
}
.slider-item {
    position: absolute;
    width: 100%;
    height: 100%;
    text-align: center;
    transition: 0.4s ease-in-out transform, opacity;
    -webkit-transition: 0.4s ease-in-out transform, opacity;
    -webkit-transition-duration: 0.4s;
    -webkit-transition-timing-function: ease-in-out;
}
</style>
<template>
    <div class="slider"
    @touchmove="swipeMove"
    @touchstart="swipeStart"
    @touchend="swipeEnd"
    @mousedown="swipeStart"
    @mouseup="swipeEnd"
    @mousemove="swipeMove"
    >
        <slot></slot>
    </div>
</template>
