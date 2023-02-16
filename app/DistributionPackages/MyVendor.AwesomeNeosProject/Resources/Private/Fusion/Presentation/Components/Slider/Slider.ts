// @ts-ignore
import Swiper from 'swiper/bundle';
// import Swiper styles
import 'swiper/css/bundle';

export default (inBackend: unknown = false) => ({
    inBackend: inBackend as boolean,
    _currentPosition: 1,

    init() {
        const scope = this;
        // listen to node created/selected events to scroll to the right slide in neos backend
        document.addEventListener('Neos.NodeCreated', function(event) {
            // @ts-ignore
            const selectedElement = event.detail.element as HTMLElement;
            scope._scrollSlideIntoView(selectedElement.closest(".swiper-slide"));
        }, false);

        document.addEventListener('Neos.NodeSelected', function(event) {
            // @ts-ignore
            const selectedElement = event.detail.element as HTMLElement;
            scope._scrollSlideIntoView(selectedElement.closest(".swiper-slide"));
        }, false);


        this._initSlider();
    },

    // used only in backend
    slideLeft(event: PointerEvent) {
        const newPosition = this._currentPosition - 1;
        this._slideTo(newPosition);
    },

    // used only in backend
    slideRight(event: PointerEvent) {
        const newPosition = this._currentPosition + 1;
        this._slideTo(newPosition);
    },

    // Custom slide handling for the neos backend
    _slideTo(newPosition: number) {
        if (!this.inBackend) {
            return;
        }

        // @ts-ignore
        const amountOfSlides = this.$refs.slider.querySelectorAll('.swiper-slide').length;
        if (amountOfSlides === 0) {
            return;
        }

        if (newPosition < 1 || newPosition > amountOfSlides) {
            return;
        }

        this._currentPosition = newPosition
        // @ts-ignore
        const slider = this.$refs.slider;
        const slideToScrollTo = slider.querySelector(".swiper-slide:nth-child(" + newPosition + ")");
        this._scrollSlideIntoView(slideToScrollTo);
    },

    _scrollSlideIntoView(slide: HTMLElement|null) {
        if (slide) {
            // @ts-ignore
            const slider = this.$refs.slider;
            slider.querySelector(".swiper-wrapper").scrollLeft = slide.offsetLeft;
        }
    },

    _initSlider() {
        // The slider is not initialized with swiper when in the neos-backend to prevent broken rendering
        if (this.inBackend) {
            return;
        }

        // @ts-ignore
        const swiperRef = this.$refs.slider;

        // @ts-ignore
        const amountOfSlides = swiperRef.querySelectorAll('.swiper-slide').length;
        if (amountOfSlides === 0) {
            return;
        }

        new Swiper(swiperRef, {
            loop: true,
            pagination: {
                el: '.swiper-pagination',
                clickable: true,
            },
            navigation: {
                nextEl: '.swiper-button-next',
                prevEl: '.swiper-button-prev',
            },
        });
    }
})
