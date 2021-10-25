import { Application } from "@hotwired/stimulus";

// We decided to use https://stimulus.hotwired.dev/ to write js code
// as it provides a great way to structure and develop js components.
import ScrollTransition from "./Fusion/Presentation/Components/ScrollTransition/ScrollTransition";

declare global {
    interface Window {
        Stimulus: any;
        ErrorTrackingSystem: any;
    }
}

const Stimulus = Application.start();
// we decided to add controllers manually as we want to use our own folder structure
// for ts/js
Stimulus.register("ScrollTransition", ScrollTransition);
Stimulus.handleError = (error, message, detail) => {
    console.warn(message, detail);
    window.ErrorTrackingSystem.captureException(error);
};

// enable if needed
// Stimulus.debug = true;

window.Stimulus = Stimulus;
