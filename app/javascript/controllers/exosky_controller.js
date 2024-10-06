//The visualization of stars and exoplanets is done using Three.js
//To understand the principles of the data we will interact with
//We need to understand the Celestial Sphere and the Equatorial Coordinate System
//The Celestial Sphere is an imaginary sphere of infinite radius surrounding the Earth
//Celestial objects use Right Ascension and Declination to describe their position on the Celestial Sphere
//Right Ascension is the celestial equivalent of longitude and it is how far east an object is from the vernal equinox
//attributeName: rac
//'rac' corresponds to the values hour, minute, and second
// astroquery.gaia library from python has rac values in kiloparsecs which is a unit of distance and we convert it to degrees


//Declination is the celestial equivalent of latitude, it is how far north or south an object is from the celestial equator
//attributeName: dec
//'dec' comes in kiloparsecs
// astroquery.gaia library from python has dec values like 0d 0m 0s


//Parallax is the apparent shift in the position of an object when viewed from two different points
//attributeName: plx
//Parallax is measured in milliarcseconds (mas) and it is used to calculate the distance to the star

//We will display stars relative to the selected exoplanet using the astroquery.gaia library
//We use a fetch to the controller action that will return the selecte exoplanet and the stars with a cone of view
import { Controller } from "@hotwired/stimulus";
import * as THREE from "three";
import { OrbitControls } from "OrbitControls";

export default class extends Controller {
  static targets = ["canvas"];

  connect() {
    console.log('Connected to exosky controller');
    
    // Initialize Three.js scene
    this.initThreeJS(); 

    // Load the initial exoplanet and stars data from the DOM attributes
    this.loadInitialData();
  }

  loadInitialData() {
    // Fetch the raw data embedded in the HTML element's data attributes
    const exoplanetData = this.element.dataset.exoplanet ? JSON.parse(this.element.dataset.exoplanet) : null;
    const starsData = this.element.dataset.stars ? JSON.parse(this.element.dataset.stars) : null;

    if (exoplanetData && starsData) {
      console.log("Initial exoplanet and star data:", exoplanetData, starsData);
      this.updateSceneWithExoplanetAndStarData({ exoplanet: exoplanetData, stars: starsData });
    } else {
      console.warn("No exoplanet or stars data found in the dataset.");
    }
  }

  initThreeJS() {
    // Initialize scene, camera, and renderer
    this.scene = new THREE.Scene();
    this.camera = new THREE.PerspectiveCamera(75, window.innerWidth / window.innerHeight, 0.1, 1000000);
    this.camera.position.set(0, 0, 5000); // Set camera position to view stars

    this.renderer = new THREE.WebGLRenderer({ antialias: true });
    this.renderer.setSize(window.innerWidth, window.innerHeight);
    this.canvasTarget.appendChild(this.renderer.domElement);

    // Orbit controls to rotate around the stars
    this.controls = new OrbitControls(this.camera, this.renderer.domElement);
    this.controls.enableDamping = true;
    this.controls.dampingFactor = 0.05;

    // Set background color to black (space)
    this.scene.background = new THREE.Color(0x000000);

    // Ambient light
    const ambientLight = new THREE.AmbientLight(0x404040);
    this.scene.add(ambientLight);

    // Start animation loop
    this.animate();
  }

  // Update the Three.js scene with exoplanet and star data
  updateSceneWithExoplanetAndStarData(data) {
    const { exoplanet, stars } = data;

    // Log the exoplanet data for debugging
    console.log('Exoplanet data:', exoplanet);

    // Update star data in the scene
    this.updateSceneWithStarData(stars);
  }

  // Update the scene with star data
  updateSceneWithStarData(starData) {
    const starGeometry = new THREE.BufferGeometry();
    const positions = [];

    starData.forEach((star, index) => {
      const { ra, dec, parallax } = star; // RA, Dec in degrees, parallax in milliarcseconds

      if (!parallax || parallax <= 0) {
        console.warn(`Star ${index + 1} has invalid parallax: ${parallax}. Skipping...`);
        return; // Skip stars with invalid or missing parallax
      }

      // Calculate distance in parsecs using the parallax value
      const distance = this.calculateDistanceFromParallax(parallax);
      let scaledDistance = distance*100

      // Convert RA/Dec to Cartesian coordinates and scale the distance
      const starPosition = this.convertRaDecToXYZ(ra, dec, scaledDistance);

      // Log star's Cartesian position
      console.log(`Star ${index + 1} Cartesian: x = ${starPosition.x}, y = ${starPosition.y}, z = ${starPosition.z}`);

      // Add the x, y, z positions into the positions array
      positions.push(starPosition.x, starPosition.y, starPosition.z);
    });

    // Set positions into buffer geometry
    starGeometry.setAttribute('position', new THREE.Float32BufferAttribute(positions, 3));

    // Create star material
    const starMaterial = new THREE.PointsMaterial({
      color: 0xffffff,
      size: 5, // Adjust star size
      transparent: true,
      opacity: 0.9,
    });

    // Create and add stars to the scene
    const stars = new THREE.Points(starGeometry, starMaterial);
    this.scene.add(stars);

    console.log('Stars added to the scene.');
  }

  // Function to calculate distance from parallax
  calculateDistanceFromParallax(parallax) {
    // Distance in parsecs (pc) = 1000 / parallax (in milliarcseconds)
    const distance = 1000 / parallax;
    console.log(`Calculated distance from parallax (${parallax} mas): ${distance} parsecs`);
    return distance;
  }

  // Convert RA/Dec to Cartesian coordinates
  convertRaDecToXYZ(ra, dec, distance) {
    const phi = THREE.MathUtils.degToRad(ra); // RA in degrees, convert to radians
    const theta = THREE.MathUtils.degToRad(90 - dec); // Dec in degrees, convert to radians

    const x = distance * Math.sin(theta) * Math.cos(phi);
    const y = distance * Math.sin(theta) * Math.sin(phi);
    const z = distance * Math.cos(theta);

    console.log(`Converted to Cartesian: x = ${x}, y = ${y}, z = ${z}`);
    return new THREE.Vector3(x, y, z);
  }

  // Animation loop
  animate() {
    requestAnimationFrame(() => this.animate());
    this.controls.update();
    this.renderer.render(this.scene, this.camera);
  }
}
