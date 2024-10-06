import { Controller } from "@hotwired/stimulus";
import { get } from "@rails/request.js"
import * as THREE from 'three';

export default class extends Controller {
  static targets = ["canvas", "exoplanet"];

  connect() {
    console.log('Test');
    // Load the galaxy image path from data attribute
    this.galaxyImage = this.element.dataset.welcomeGalaxy;

    // Initialize the Three.js scene
    this.initThreeJS();
  }

  initThreeJS() {
    const container = this.canvasTarget;

    // Setup Three.js scene
    this.scene = new THREE.Scene();

    // Set up a camera with a wide field of view to simulate looking around
    this.camera = new THREE.PerspectiveCamera(75, container.clientWidth / container.clientHeight, 0.1, 10000);
    this.camera.position.set(0, 0, 0);  // Set the camera at the center of the dome

    // Set up WebGLRenderer
    this.renderer = new THREE.WebGLRenderer({ antialias: true });
    this.renderer.setSize(container.clientWidth, container.clientHeight);
    container.appendChild(this.renderer.domElement);

    // Load the texture for the background (galaxy image)
    const textureLoader = new THREE.TextureLoader();
    const galaxyTexture = textureLoader.load(this.galaxyImage);

    // Adjust texture wrapping (optional)
    galaxyTexture.wrapS = THREE.RepeatWrapping;
    galaxyTexture.wrapT = THREE.RepeatWrapping;

    // Create a sphere geometry (the dome)
    const sphereGeometry = new THREE.SphereGeometry(900, 100, 100); // Large sphere
    const sphereMaterial = new THREE.MeshBasicMaterial({
      map: galaxyTexture,
      side: THREE.BackSide, // Render the inside of the sphere
    });

    // Create the sphere mesh and add it to the scene
    this.sphere = new THREE.Mesh(sphereGeometry, sphereMaterial);
    this.scene.add(this.sphere);

    // Render loop
    this.animate();

    // Handle window resize to keep the renderer responsive
    window.addEventListener('resize', () => this.onWindowResize());
  }

  animate() {
    requestAnimationFrame(() => this.animate());

    // Optional slow rotation of the sphere (dome) for visual effect
    this.sphere.rotation.x += 0.0001;
    this.sphere.rotation.y += 0.0001;

    this.renderer.render(this.scene, this.camera);
  }

  onWindowResize() {
    const container = this.canvasTarget;
    this.camera.aspect = container.clientWidth / container.clientHeight;
    this.camera.updateProjectionMatrix();
    this.renderer.setSize(container.clientWidth, container.clientHeight);
  }

  // Handle Exoplanet Selection
  selectExoplanet(event) {
    const exoplanetId = event.target.value;
    get(`/exoplanets/${exoplanetId}/loading`, {
        responseKind: "turbo-stream"
    });
  }
}
