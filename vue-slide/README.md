# vue-slide

# Demo

![](http://ww4.sinaimg.cn/large/675f4a91jw1f1w7pyfbf8g20lm0hakjm.gif)

The demo page is [HERE](http://hilongjw.github.io/vue-slide/demo.html).

# Instllation

## npm

```shell
$ npm install vue-slide
```

# Usage

app.vue

```html
<template>
    <div class="container">
        <!-- pagination example -->
        <div class="timeline">
            <div 
                class="item"
                @click='turnTo (1)'
                :class='{"active": slide.init.currentPage == 1}'
            >page1</div>
            <div 
                class="item"
                @click='turnTo (2)'
                :class='{"active": slide.init.currentPage == 2}'
            >page2</div>
            <div 
                class="item"
                @click='turnTo (3)'
                :class='{"active": slide.init.currentPage == 3}'
            >page3</div>
        </div>

        <!-- next and pre method -->
        <img 
            src="./assets/images/slide-arrow.svg" 
            class="slider-left"
            @click='slidePre'
            :class='{"disable": !this.slide.init.canPre}'
        >
        <img 
            src="./assets/images/slide-arrow.svg" 
            class="slider-right"
            @click='slideNext'
            :class='{"disable": !this.slide.init.canNext}'
        >

        <!-- bind init and pageList -->

        <slide :pages="someList" :slide="slide">
        
            <!-- slot  -->
            <div 
                v-for="item in someList"
                class="slider-item page{{$index}}" 
                :style="someList[$index].style">
                <h1>{{item.title}}</h1>
                <button @click="turnTo(($index+2))">to page{{$index+1}}</button>
            </div>

        </slide>
    </div>
    
</template>
<script>
import slide from 'vue-slide'
export default {
    data () {
        return {
            someList:[
                {
                    title: '1',
                    img: 'testimg-1.png',
                    //slide init
                    origin: 0,
                    current: 0,
                    style:{
                        'background-image': 'url(dist/testimg-1.png)',
                        'background-size': 'cover',
                        //transform
                        'transform': `translateX(0%)`
                    }
                },
                {
                    title: '2',
                    img: 'testimg-2.png',
                    
                    origin: 100,
                    current: 0,
                    style:{
                        'background-image': 'url(dist/testimg-2.png)',
                        'background-size': 'cover',
                        'transform': `translateX(${ 100 }%)`
                    }
                },
                {
                    title: '3',
                    img: 'testimg-3.png',
                    origin: 200,
                    current: 0,
                    style:{
                        'background-image': 'url(dist/testimg-3.png)',
                        'background-size': 'cover',
                        'transform': `translateX(${ 200 }%)`
                    }
                }
            ],
            slide: {
                init: {
                    pageNum: 3,
                    currentPage: 1,
                    canPre : false,
                    canNext: true,
                    start: {},
                    end: {},
                    tracking: false,
                    thresholdTime: 500,
                    thresholdDistance: 100
                }
            }
            
        }
    },
    methods: {
        turnTo (num) {
            console.log(num)
            this.$broadcast('slideTo', num)
        },
        slideNext () {
            this.$broadcast('slideNext')
        },
        slidePre () {
            this.$broadcast('slidePre')
        }
    },
    components: {
        slide
    }
}
</script>


```


# License

[The MIT License](http://opensource.org/licenses/MIT)

