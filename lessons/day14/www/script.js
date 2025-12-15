// ====== Helpers ======
function $(id) {
  return document.getElementById(id);
}

function showToast(message) {
  const toast = document.createElement("div");
  toast.className = "toast";
  toast.textContent = message;
  document.body.appendChild(toast);

  setTimeout(() => toast.remove(), 2000);
}

// ====== Elements ======
const counterButton = $("counterButton");
const counterSpan = $("counter");
const colorButton = $("colorButton");
const statusElement = $("status");

// ====== State (persisted) ======
let counter = Number(localStorage.getItem("clickCounter") || 0);
let isDarkTheme = localStorage.getItem("darkTheme") === "true";

// ====== Init on load ======
document.addEventListener("DOMContentLoaded", () => {
  // Restore counter
  if (counterSpan) counterSpan.textContent = counter;

  // Restore theme
  if (isDarkTheme) {
    document.body.classList.add("dark-theme");
    if (colorButton) colorButton.textContent = "Light Theme";
  } else {
    if (colorButton) colorButton.textContent = "Dark Theme";
  }

  // Animate cards
  animateOnLoad();

  // Status rotation
  updateStatus();
  setInterval(updateStatus, 4000);

  // Hover effects
  addCardHoverEffects();
});

// ====== Counter functionality ======
if (counterButton && counterSpan) {
  counterButton.addEventListener("click", () => {
    counter++;
    counterSpan.textContent = counter;

    // Save counter
    localStorage.setItem("clickCounter", String(counter));

    // Button feedback (uses .btn.pressed in CSS)
    counterButton.classList.add("pressed");
    setTimeout(() => counterButton.classList.remove("pressed"), 150);

    // Milestones
    if (counter % 10 === 0) {
      showCelebration();
      showToast("🎉 Milestone reached!");
    } else if (counter % 5 === 0) {
      showToast("✅ Nice progress!");
    }
  });
}

// ====== Theme toggle ======
if (colorButton) {
  colorButton.addEventListener("click", () => {
    isDarkTheme = !isDarkTheme;
    document.body.classList.toggle("dark-theme");

    colorButton.textContent = isDarkTheme ? "Light Theme" : "Dark Theme";
    localStorage.setItem("darkTheme", String(isDarkTheme));

    showToast(isDarkTheme ? "🌙 Dark Theme Enabled" : "☀️ Light Theme Enabled");
  });
}

// ====== Animation on page load ======
function animateOnLoad() {
  const cards = document.querySelectorAll(".feature-card");
  cards.forEach((card, index) => {
    card.style.opacity = "0";
    card.style.transform = "translateY(16px)";

    setTimeout(() => {
      card.style.transition = "all 0.5s ease";
      card.style.opacity = "1";
      card.style.transform = "translateY(0)";
    }, index * 120);
  });
}

// ====== Celebration effect ======
function showCelebration() {
  const celebration = document.createElement("div");
  celebration.textContent = "🎉";
  celebration.style.cssText = `
    position: fixed;
    top: 18%;
    left: 50%;
    transform: translateX(-50%);
    font-size: 3rem;
    pointer-events: none;
    z-index: 1000;
    animation: pop 1s ease-out forwards;
  `;

  const style = document.createElement("style");
  style.textContent = `
    @keyframes pop {
      0% { transform: translateX(-50%) scale(0.6); opacity: 0; }
      30% { transform: translateX(-50%) scale(1.2); opacity: 1; }
      100% { transform: translateX(-50%) scale(1.6); opacity: 0; }
    }
  `;

  document.head.appendChild(style);
  document.body.appendChild(celebration);

  setTimeout(() => {
    celebration.remove();
    style.remove();
  }, 1000);
}

// ====== Status updates ======
function updateStatus() {
  if (!statusElement) return;

  const statuses = ["Optimized", "Secure", "Fast", "Highly Available"];
  const randomStatus = statuses[Math.floor(Math.random() * statuses.length)];

  statusElement.style.opacity = "0.5";
  setTimeout(() => {
    statusElement.textContent = randomStatus;
    statusElement.style.opacity = "1";
  }, 250);
}

// ====== Card hover effects ======
function addCardHoverEffects() {
  const featureCards = document.querySelectorAll(".feature-card");

  featureCards.forEach((card) => {
    card.addEventListener("mouseenter", function () {
      this.style.transform = "translateY(-10px) scale(1.02)";
    });

    card.addEventListener("mouseleave", function () {
      this.style.transform = "translateY(0) scale(1)";
    });
  });
}

// ====== Keyboard shortcuts ======
document.addEventListener("keydown", (e) => {
  if (e.code === "Space") {
    e.preventDefault();
    counterButton?.click();
  }

  if (e.key === "t" || e.key === "T") {
    colorButton?.click();
  }
});

// ====== Basic performance logging ======
window.addEventListener("load", () => {
  const timing = window.performance?.timing;
  if (!timing) return;

  const loadTime = timing.loadEventEnd - timing.navigationStart;
  console.log(`Page loaded in ${loadTime}ms`);
  console.log("🚀 Demo: S3 + CloudFront + Terraform");
  console.log("⌨️ Shortcuts: Space (counter), T (theme)");
});
