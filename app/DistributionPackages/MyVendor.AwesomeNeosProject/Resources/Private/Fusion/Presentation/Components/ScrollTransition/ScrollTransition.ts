import { Controller } from "@hotwired/stimulus";

// We decided to use https://stimulus.hotwired.dev/ to write js code
// as it provides a great way to structure and develop js components.

function supportsIntersectionObserver() {
	return (
		"IntersectionObserver" in window ||
		"IntersectionObserverEntry" in window ||
		"intersectionRatio" in window.IntersectionObserverEntry.prototype
	);
}

export default class extends Controller {
	// workaround to type readonly element
	// this will return the element that was detected as controller
	get el(): HTMLElement {
		return this.element as HTMLElement;
	}

	intersectionObserver!: IntersectionObserver;

	// Targets -> https://stimulus.hotwired.dev/reference/targets
	// With data-ScrollTransition-target="someElement" and static targets = ["someElement"];
	// you tell Stimulus to provide the element in `this.someElementTarget`

	connect() {
		if (supportsIntersectionObserver()) {
			this.el.classList.add("ScrollTransition--hide");
			this.intersectionObserver = new IntersectionObserver(
				this.transition.bind(this),
				{ threshold: 0.5 }
			);
			this.intersectionObserver.observe(this.el);
		} else {
			// No Transitions when scrolling
		}
	}

	transition(entry: IntersectionObserverEntry[]) {
		if (entry[0].isIntersecting) {
			this.el.classList.remove("ScrollTransition--hide");
		}
	}
}
