// @ts-ignore
import Alpine from 'alpinejs';
// @ts-ignore
import intersect from '@alpinejs/intersect';
import "./main.scss";
import {initMap} from "./Fusion/Presentation/Components/Map/Map";
import slider from "./Fusion/Presentation/Components/Slider/Slider";

// We decided to use https://alpinejs.dev/ to write js code
// as it provides a great way to structure and develop js components.
Alpine.plugin(intersect)
initMap(Alpine);

Alpine.data('slider', slider)

Alpine.start();
