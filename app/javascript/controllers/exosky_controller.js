import { Controller } from "@hotwired/stimulus"
import * as THREE from "three"
import { OrbitControls } from "OrbitControls"

// Stimulus controller to handle the Three.js scene
export default class extends Controller {
  static targets = ["canvas", "exoplanet"]

  connect() {
    this.raycastTargets = [] // Store all groups for raycasting
    this.gasSurface = this.element.dataset.exoskyGasSurface
    this.gasBump = this.element.dataset.exoskyGasBump
    this.waterSurface = this.element.dataset.exoskyWaterSurface
    this.waterBump = this.element.dataset.exoskyWaterBump
    this.rockSurface = this.element.dataset.exoskyRockSurface
    this.rockBump = this.element.dataset.exoskyRockBump

    this.initThreeJS()
  }


  initThreeJS() {
    let container;
    const clock = new THREE.Clock();
  
    // Create container
    container = document.createElement('div');
    this.canvasTarget.appendChild(container);
  
    // Initialize camera
    this.camera = new THREE.PerspectiveCamera(40, window.innerWidth / window.innerHeight, 1, 15000);
    this.camera.position.set(0, 200, 3000);
  
    // Initialize scene
    this.scene = new THREE.Scene();
    this.scene.background = new THREE.Color(0x000000); // Black background for night sky
  
    // Initialize renderer
    this.renderer = new THREE.WebGLRenderer({ antialias: true });
    this.renderer.setPixelRatio(window.devicePixelRatio);
    this.renderer.setSize(window.innerWidth, window.innerHeight);
    container.appendChild(this.renderer.domElement);
  
    // OrbitControls - let the user rotate around the exoplanet
    this.controls = new OrbitControls(this.camera, this.renderer.domElement);
    this.controls.enableDamping = true; // Enable damping (inertia)
    this.controls.dampingFactor = 0.05; // Damping factor
    this.controls.screenSpacePanning = false; // Disable pan
    this.controls.minDistance = 1500; // Limit how close the camera can get
    this.controls.maxDistance = 5000; // Limit how far the camera can go
    this.controls.target.set(0, 0, 0); // Focus on the exoplanet at (0, 0, 0)
  
    // Raycaster and mouse setup for detecting hovering
    this.raycaster = new THREE.Raycaster();
    this.mouse = new THREE.Vector2();
  
    window.addEventListener('mousemove', this.onMouseMove.bind(this));
    window.addEventListener('resize', this.onWindowResize.bind(this));
  
    const animate = () => {
      requestAnimationFrame(animate);
      this.controls.update(); // Update the controls with the damping effect
      this.renderer.render(this.scene, this.camera);
      this.checkIntersections(); // Check for raycasting intersections
    };
  
    animate(); // Start the animation loop
  }
  
  onWindowResize() {
    this.renderer.setSize(window.innerWidth, window.innerHeight);
    this.camera.aspect = window.innerWidth / window.innerHeight;
    this.camera.updateProjectionMatrix();
  }
  
  onMouseMove(event) {
    // Calculate mouse position in normalized device coordinates (-1 to +1) for both axes
    this.mouse.x = (event.clientX / window.innerWidth) * 2 - 1;
    this.mouse.y = -(event.clientY / window.innerHeight) * 2 + 1;
  
    // Pass the event to use in positioning the constellation name
    this.currentMouseEvent = event;
  }
  

  selectExoplanet(event) {
    const exoplanetId = event.target.value
    this.fetchExoplanetData(exoplanetId)
  }

  fetchExoplanetData(exoplanetId) {
    fetch(`/exoplanets/${exoplanetId}/night_sky`)
      .then(response => response.json())
      .then(data => {
        this.updateSceneWithExoplanetData(data)
      })
      .catch(error => console.error('Error fetching exoplanet data:', error))
  }

  updateSceneWithExoplanetData(exoplanet) {
    const { ra, dec, sy_dist, st_teff, st_rad, pl_rade, pl_bmasse, sy_vmag, pl_orbper, pl_eqt } = exoplanet

    while (this.scene.children.length > 0) {
      this.scene.remove(this.scene.children[0])
    }

    this.addStars(ra, dec, sy_dist, st_teff, sy_vmag)
    this.addExoplanet(pl_rade, pl_bmasse, pl_eqt, pl_orbper)
    this.addConstellations()

    this.camera.position.set(0, -pl_rade * 200, pl_rade * 200)
    this.camera.lookAt(0, 0, 0)
  }

  addStars(ra, dec, sy_dist, st_teff, sy_vmag) {
    const starCount = 2000
    const positions = []
    const colors = []

    for (let i = 0; i < starCount; i++) {
      const x = THREE.MathUtils.randFloatSpread(40000)
      const y = THREE.MathUtils.randFloatSpread(40000)
      const z = THREE.MathUtils.randFloatSpread(40000)

      positions.push(x, y, z)
      const color = this.getStarColor(st_teff)
      colors.push(color.r, color.g, color.b)
    }

    const positionAttribute = new THREE.Float32BufferAttribute(positions, 3)
    const colorAttribute = new THREE.Float32BufferAttribute(colors, 3)

    const geometry = new THREE.BufferGeometry()
    geometry.setAttribute('position', positionAttribute)
    geometry.setAttribute('color', colorAttribute)

    const starMaterial = new THREE.PointsMaterial({
      size: 10,
      vertexColors: true,
      sizeAttenuation: true,
      transparent: true,
      opacity: 0.9,
    })

    const stars = new THREE.Points(geometry, starMaterial)
    this.scene.add(stars)
  }

  addConstellations() {
    const constellations = [
      // Orion
      {
        name: "Orion",
        stars: [
          { ra: 5.9195, dec: 7.4071 },  // Betelgeuse
          { ra: 5.2782, dec: -8.2016 }, // Rigel
          { ra: 5.6036, dec: -1.2019 }, // Bellatrix
          { ra: 5.4189, dec: -0.2991 }, // Alnilam
          { ra: 5.2423, dec: -8.2016 }  // Saiph
        ]
      },
      // Ursa Major
      {
        name: "Ursa Major",
        stars: [
          { ra: 11.0621, dec: 61.7510 },  // Dubhe
          { ra: 13.7923, dec: 49.3133 },  // Merak
          { ra: 11.8972, dec: 53.6948 },  // Phecda
          { ra: 12.2577, dec: 57.0326 },  // Megrez
          { ra: 12.9004, dec: 55.9598 },  // Alioth
          { ra: 13.4204, dec: 54.9254 },  // Mizar
          { ra: 14.0602, dec: 49.3145 }   // Alkaid
        ]
      },
      // Cassiopeia
      {
        name: "Cassiopeia",
        stars: [
          { ra: 0.9455, dec: 60.7167 },   // Caph
          { ra: 0.6750, dec: 56.5373 },   // Schedar
          { ra: 1.4303, dec: 63.0637 },   // Gamma Cassiopeiae
          { ra: 1.9066, dec: 62.2958 },   // Ruchbah
          { ra: 2.2938, dec: 59.1498 }    // Segin
        ]
      },
      // Scorpius
      {
        name: "Scorpius",
        stars: [
          { ra: 16.4901, dec: -26.4319 }, // Antares
          { ra: 17.5602, dec: -37.1038 }, // Shaula
          { ra: 16.8361, dec: -34.2933 }, // Sargas
          { ra: 16.0056, dec: -22.6217 }  // Dschubba
        ]
      },
      // Taurus
      {
        name: "Taurus",
        stars: [
          { ra: 4.5987, dec: 16.5093 },   // Aldebaran
          { ra: 3.7914, dec: 24.1053 },   // Elnath
          { ra: 5.6275, dec: 28.6056 }    // Alcyone (in the Pleiades)
        ]
      },
      // Lyra
      {
        name: "Lyra",
        stars: [
          { ra: 18.6156, dec: 38.7837 },  // Vega
          { ra: 18.7461, dec: 32.8125 },  // Sheliak
          { ra: 18.8348, dec: 33.3627 }   // Sulafat
        ]
      },
      // Draco
      {
        name: "Draco",
        stars: [
          { ra: 17.1469, dec: 65.7146 },  // Eltanin
          { ra: 17.5078, dec: 52.3013 },  // Rastaban
          { ra: 15.7376, dec: 77.7942 },  // Thuban
          { ra: 19.0901, dec: 67.6552 }   // Edasich
        ]
      },
      // Sagittarius
      {
        name: "Sagittarius",
        stars: [
          { ra: 19.0435, dec: -29.8801 }, // Kaus Australis
          { ra: 18.3491, dec: -29.8282 }, // Kaus Media
          { ra: 18.4029, dec: -34.3847 }, // Kaus Borealis
          { ra: 18.9211, dec: -26.2967 }  // Nunki
        ]
      },
      // Canis Major
      {
        name: "Canis Major",
        stars: [
          { ra: 6.7525, dec: -16.7161 },  // Sirius
          { ra: 7.4016, dec: -29.3031 },  // Adhara
          { ra: 6.9351, dec: -24.1838 },  // Wezen
          { ra: 7.1399, dec: -26.3932 },  // Aludra
          { ra: 6.9770, dec: -17.9559 }   // Mirzam
        ]
      },
      // Cygnus
      {
        name: "Cygnus",
        stars: [
          { ra: 20.6905, dec: 45.2803 },  // Deneb
          { ra: 19.5121, dec: 27.9597 },  // Albireo
          { ra: 21.3097, dec: 38.6619 },  // Sadr
          { ra: 19.7490, dec: 34.5346 }   // Gienah
        ]
      },
      // Aquarius
      {
        name: "Aquarius",
        stars: [
          { ra: 22.0964, dec: -0.3199 },  // Sadalmelik
          { ra: 21.5263, dec: -5.5712 },  // Sadalsuud
          { ra: 23.2804, dec: -21.0006 }, // Skat
          { ra: 22.8755, dec: -7.5797 }   // Sadachbia
        ]
      },
      // Andromeda
      {
        name: "Andromeda",
        stars: [
          { ra: 0.1398, dec: 29.0904 },   // Alpheratz
          { ra: 0.9451, dec: 38.4996 },   // Mirach
          { ra: 2.0656, dec: 42.3297 },   // Almach
          { ra: 2.1587, dec: 33.8472 }    // Adhil
        ]
      },
      // Pegasus
      {
        name: "Pegasus",
        stars: [
          { ra: 21.7365, dec: 25.3451 },  // Markab
          { ra: 22.0964, dec: 15.3450 },  // Scheat
          { ra: 22.7111, dec: 24.1156 },  // Algenib
          { ra: 23.0794, dec: 28.0817 }   // Enif
        ]
      },
      // Leo
      {
        name: "Leo",
        stars: [
          { ra: 10.3325, dec: 11.9672 },  // Regulus
          { ra: 11.2351, dec: 20.5237 },  // Algieba
          { ra: 9.8793, dec: 26.0060 },   // Denebola
          { ra: 10.1225, dec: 23.4177 }   // Zosma
        ]
      },
      // Perseus
      {
        name: "Perseus",
        stars: [
          { ra: 3.0796, dec: 38.8408 },   // Mirfak
          { ra: 2.8432, dec: 38.3186 },   // Algol
          { ra: 3.4054, dec: 48.1920 },   // Atik
          { ra: 2.4040, dec: 40.9556 }    // Menkib
        ]
      }
    ]
    const starTexturePath = this.element.dataset.exoskyStar;
    const starTexture = new THREE.TextureLoader().load(starTexturePath); // Load texture dynamically



    constellations.forEach(constellation => {
      // Create a group to hold all stars and lines of the constellation
      const constellationGroup = new THREE.Group();
  
      constellation.stars.forEach((star, index) => {
        const start = this.convertRaDecToXYZ(star.ra, star.dec, 10000);
  
        // Create smaller, more natural stars with a glow effect using the texture from HTML
        const starMaterial = new THREE.SpriteMaterial({ map: starTexture, color: 0xffffff, transparent: true });
        const starMesh = new THREE.Sprite(starMaterial);
        starMesh.scale.set(40, 40, 1); // Larger size for easier hovering
        starMesh.position.copy(start);
  
        constellationGroup.add(starMesh);
  
        // Create a larger "hover hitbox" around the star
        const hitboxGeometry = new THREE.SphereGeometry(300, 300, 300); // Much larger sphere for hover detection
        const hitboxMaterial = new THREE.MeshBasicMaterial({ color: 0xffffff, transparent: true, opacity: 0 });
        const hitbox = new THREE.Mesh(hitboxGeometry, hitboxMaterial);
        hitbox.position.copy(start);
        constellationGroup.add(hitbox);
  
        // Create transparent lines between stars (initially low opacity)
        if (index < constellation.stars.length - 1) {
          const nextStar = constellation.stars[index + 1];
          const end = this.convertRaDecToXYZ(nextStar.ra, nextStar.dec, 10000);
  
          const geometry = new THREE.BufferGeometry().setFromPoints([start, end]);
          const material = new THREE.LineBasicMaterial({
            color: 0xffffff,
            transparent: true,
            opacity: 0.1, // Initially almost invisible
            linewidth: 1,
          });
  
          const line = new THREE.Line(geometry, material);
          constellationGroup.add(line);
  
          // Create a larger invisible "hover hitbox" around the line
          const hitboxLineGeometry = new THREE.CylinderGeometry(50, 50, start.distanceTo(end), 32); // Larger cylinder for line hover detection
          const hitboxLineMaterial = new THREE.MeshBasicMaterial({ color: 0xffffff, transparent: true, opacity: 0 });
          const hitboxLine = new THREE.Mesh(hitboxLineGeometry, hitboxLineMaterial);
  
          // Position the hitbox at the midpoint of the line
          hitboxLine.position.copy(start.clone().add(end).multiplyScalar(0.5));
          hitboxLine.lookAt(end); // Align the cylinder with the line
          constellationGroup.add(hitboxLine);
        }
      });
  
      this.scene.add(constellationGroup);
  
      // Add hover effect for the entire constellation group
      constellationGroup.userData.isHovered = false;
      constellationGroup.userData.name = constellation.name; // Store the constellation name
  
      constellationGroup.traverse(obj => {
        obj.userData.constellationGroup = constellationGroup; // Attach the group to each object
      });
  
      // Raycaster to highlight the entire constellation on hover
      this.raycastTargets.push(constellationGroup); // Store group for raycasting
    });
  }

  convertRaDecToXYZ(ra, dec, distance) {
    const phi = THREE.MathUtils.degToRad(ra * 15) // Convert RA to degrees, then radians
    const theta = THREE.MathUtils.degToRad(90 - dec) // Convert DEC to radians

    const x = distance * Math.sin(theta) * Math.cos(phi)
    const y = distance * Math.sin(theta) * Math.sin(phi)
    const z = distance * Math.cos(theta)

    return new THREE.Vector3(x, y, z)
  }

  getStarColor(st_teff) {
    let color

    if (st_teff > 7500) color = new THREE.Color(0xadd8e6)
    else if (st_teff > 6000) color = new THREE.Color(0xfffff0)
    else if (st_teff > 5000) color = new THREE.Color(0xffdd44)
    else color = new THREE.Color(0xff4500)

    return color
  }

  addExoplanet(pl_rade, pl_bmasse, pl_eqt, pl_orbper) {
    const exoplanetGeometry = new THREE.SphereGeometry(pl_rade * 100, 64, 64)

    const planetTexture = this.getPlanetTexture(pl_rade, pl_bmasse, pl_eqt)

    const textureLoader = new THREE.TextureLoader()
    const surfaceTexture = textureLoader.load(planetTexture.surface)
    const bumpMap = textureLoader.load(planetTexture.bump)

    const exoplanetMaterial = new THREE.MeshStandardMaterial({
      map: surfaceTexture,
      bumpMap: bumpMap,
      bumpScale: 0.05,
      metalness: 0.3,
      roughness: 0.7,
    })

    const exoplanet = new THREE.Mesh(exoplanetGeometry, exoplanetMaterial)

    exoplanet.rotation.x = pl_orbper / 1000
    exoplanet.rotation.y = pl_orbper / 1000

    exoplanet.position.set(0, 0, 0)
    this.scene.add(exoplanet)

    const directionalLight = new THREE.DirectionalLight(0xffffff, 1)
    directionalLight.position.set(1000, 1000, 1000).normalize()
    this.scene.add(directionalLight)

    const glowMaterial = new THREE.ShaderMaterial({
      uniforms: {
        'c': { type: 'f', value: 0.6 },
        'p': { type: 'f', value: 6.0 },
        glowColor: { type: 'c', value: new THREE.Color(0x0077ff) },
        viewVector: { type: 'v3', value: this.camera.position },
      },
      vertexShader: `
        uniform vec3 viewVector;
        varying float intensity;
        void main() {
          vec3 vNormal = normalize(normalMatrix * normal);
          vec3 vNormel = normalize(normalMatrix * viewVector);
          intensity = pow(0.6 - dot(vNormal, vNormel), 6.0);
          gl_Position = projectionMatrix * modelViewMatrix * vec4(position, 1.0);
        }
      `,
      fragmentShader: `
        uniform vec3 glowColor;
        varying float intensity;
        void main() {
          vec3 glow = glowColor * intensity;
          gl_FragColor = vec4(glow, 1.0);
        }
      `,
      side: THREE.BackSide,
      blending: THREE.AdditiveBlending,
      transparent: true,
    })

    const glowGeometry = new THREE.SphereGeometry(pl_rade * 110, 64, 64)
    const exoplanetGlow = new THREE.Mesh(glowGeometry, glowMaterial)
    this.scene.add(exoplanetGlow)
  }

  assetPath(fileType) {
    switch (fileType) {
      case 'gas':
        return { surface: this.gasSurface, bump: this.gasBump }
      case 'water':
        return { surface: this.waterSurface, bump: this.waterBump }
      case 'rock':
        return { surface: this.rockSurface, bump: this.rockBump }
      default:
        return { surface: '', bump: '' }
    }
  }

  getPlanetTexture(pl_rade, pl_bmasse, pl_eqt) {
    let textureSet = {}

    if (pl_bmasse > 100) {
      textureSet = this.assetPath('gas')
    } else if (pl_eqt < 300) {
      textureSet = this.assetPath('water')
    } else {
      textureSet = this.assetPath('rock')
    }

    return textureSet
  }

  checkIntersections() {
    if (!this.raycastTargets || this.raycastTargets.length === 0) {
      return; // No targets to check
    }
  
    // Update the raycaster with the current mouse position and camera
    this.raycaster.setFromCamera(this.mouse, this.camera);
  
    // Get the objects that can be intersected (all groups in raycastTargets)
    const intersects = this.raycaster.intersectObjects(this.raycastTargets, true);
  
    // Reset hover states for all groups
    this.raycastTargets.forEach(group => {
      if (group.userData.isHovered) {
        group.traverse(obj => {
          if (obj instanceof THREE.Line) obj.material.opacity = 0.1;
        });
      }
      group.userData.isHovered = false;
    });
  
    // If a constellation is intersected
    if (intersects.length > 0) {
      const intersectedGroup = intersects[0].object.userData.constellationGroup;
      intersectedGroup.userData.isHovered = true;
  
      // Highlight all stars and lines in the constellation group
      intersectedGroup.traverse(obj => {
        if (obj instanceof THREE.Line) {
          obj.material.opacity = 1.0; // Make lines visible on hover
        }
      });
  
      // Display the constellation name in an HTML element
      this.showConstellationName(intersectedGroup.userData.name);
    } else {
      // Hide the name if nothing is hovered
      this.hideConstellationName();
    }
  }
  
  showConstellationName(name) {
    const event = this.currentMouseEvent;
    let nameElement = document.getElementById('constellation-name');
  
    if (!nameElement) {
      nameElement = document.createElement('div');
      nameElement.id = 'constellation-name';
      nameElement.style.position = 'absolute';
      nameElement.style.padding = '5px';
      nameElement.style.backgroundColor = 'rgba(0, 0, 0, 0.7)';
      nameElement.style.color = 'white';
      nameElement.style.fontSize = '16px';
      nameElement.style.pointerEvents = 'none';
      document.body.appendChild(nameElement);
    }
  
    nameElement.style.display = 'block';
    nameElement.innerText = name;
  
    // Use the mouse event's clientX and clientY to position the label
    nameElement.style.top = `${event.clientY + 20}px`; // Offset slightly from the mouse cursor
    nameElement.style.left = `${event.clientX + 20}px`; // Offset slightly from the mouse cursor
  }
  
  
  
  hideConstellationName() {
    const nameElement = document.getElementById('constellation-name');
    if (nameElement) {
      nameElement.style.display = 'none';
    }
  }
  
}