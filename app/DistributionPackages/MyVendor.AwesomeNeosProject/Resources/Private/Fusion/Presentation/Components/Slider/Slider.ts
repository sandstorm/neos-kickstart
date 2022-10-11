// @ts-ignore
import Glide from '@glidejs/glide'

export default (inBackend: unknown = false) => ({
    inBackend: inBackend as boolean,
    _currentPosition: 1,

    // init is called before alpine.js renders the appropriate component in the DOM.
    // In this case we create a new Glide Slider for the referenced Slider (x-ref="glide") in the DOM.
    // Have a look at https://alpinejs.dev/component/glide on how to use and extend the slider/glide
    init() {
        const scope = this;
        // listen to node created/selected events to scroll to the right slide in neos backend
        document.addEventListener('Neos.NodeCreated', function(event) {
            // @ts-ignore
            const selectedElement = event.detail.element as HTMLElement;
            scope._scrollSlideIntoView(selectedElement.closest(".glide__slide"));
        }, false);

        document.addEventListener('Neos.NodeSelected', function(event) {
            // @ts-ignore
            const selectedElement = event.detail.element as HTMLElement;
            scope._scrollSlideIntoView(selectedElement.closest(".glide__slide"));
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
        const amountOfSlides = this.$refs.glide.querySelectorAll('.glide__slide').length;
        if (amountOfSlides === 0) {
            return;
        }

        if (newPosition < 1 || newPosition > amountOfSlides) {
            return;
        }

        this._currentPosition = newPosition
        // @ts-ignore
        const slider = this.$refs.glide;
        const slideToScrollTo = slider.querySelector(".glide__slide:nth-child(" + newPosition + ")");
        this._scrollSlideIntoView(slideToScrollTo);
    },

    _scrollSlideIntoView(slide: HTMLElement|null) {
        if (slide) {
            // @ts-ignore
            const slider = this.$refs.glide;
            slider.querySelector(".glide__slides").scrollLeft = slide.offsetLeft;
        }
    },

    _initSlider() {
        // The slider is not initialized with glide when in the neos-backend to prevent broken rendering
        if (this.inBackend) {
            return;
        }
        // @ts-ignore
        const amountOfSlides = this.$refs.glide.querySelectorAll('.glide__slide').length;
        if (amountOfSlides === 0) {
            return;
        }
        // @ts-ignore
        new Glide(this.$refs.glide, {
            type: 'carousel',
            perView: 1
        }).mount()
    }
})
