// Set the date to count down to

const urlParams = new URLSearchParams(window.location.search);
let countdownDate = new Date("Dec 31, 2024 24:00:00").getTime();
const endDate = urlParams.get('endDate');
const title = urlParams.get("title");

if (endDate != null) {
  countdownDate = Date.parse(endDate);
}

if (title != null) {
  document.querySelector("h1.heading").textContent = title;
}


const now = new Date().getTime();

// Check if countdown date has passed
if (now > countdownDate) {
  document.getElementById("countdown").innerHTML = "<p>The countdown is over!</p>";
  gsap.fromTo("#countdown p", { opacity: 0, y: -20 }, { opacity: 1, y: 0, duration: 1.5, ease: "bounce.out" });
} else {
  // GSAP intro animation for heading and time sections
  gsap.from(".heading", { duration: 1.5, opacity: 0, y: -50, ease: "power4.out" });
  gsap.from(".time-section", { duration: 1.5, opacity: 0, y: 50, stagger: 0.3, ease: "power4.out" });

  // Update the countdown every second
  const countdownInterval = setInterval(() => {
    const now = new Date().getTime();
    const distance = countdownDate - now;

    if (distance > 0) {
      // Calculate days, hours, minutes, and seconds
      const days = Math.floor(distance / (1000 * 60 * 60 * 24));
      const hours = Math.floor((distance % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60));
      const minutes = Math.floor((distance % (1000 * 60 * 60)) / (1000 * 60));
      const seconds = Math.floor((distance % (1000 * 60)) / 1000);

      // Pluralize time labels based on values
      document.getElementById("days").textContent = days;
      document.getElementById("days-label").textContent = days <= 1 ? "Day" : "Days";
      document.getElementById("hours").textContent = hours;
      document.getElementById("hours-label").textContent = hours <= 1 ? "Hour" : "Hours";
      document.getElementById("minutes").textContent = minutes;
      document.getElementById("minutes-label").textContent = minutes <= 1 ? "Minute" : "Minutes";
      document.getElementById("seconds").textContent = seconds;
      document.getElementById("seconds-label").textContent = seconds <= 1 ? "Second" : "Seconds";

      // Pulse animation on every update
      gsap.fromTo(
        ".count-number",
        { scale: 1 },
        { scale: 1.2, duration: 0.3, ease: "power1.inOut", yoyo: true, repeat: 1 }
      );        
    }

    // If the countdown is finished
    if (distance <= 0) {
      clearInterval(countdownInterval);  // Stop the timer updates

      // Animate countdown to fade out and slide up smoothly
      gsap.to("#countdown", {
        opacity: 0,
        y: -20,
        duration: 1,
        ease: "power3.in",
        onComplete: () => {
          document.getElementById("countdown").innerHTML = "<p>The countdown is over!</p>";
          gsap.fromTo("#countdown p", { opacity: 0, y: -20 }, { opacity: 1, y: 0, duration: 1.5, ease: "bounce.out" });
          gsap.to(".heading", {
            y: 20, // Move down by 20 pixels
            duration: 0.5,
          });
    
        }
      });

      // Animate the heading to move down smoothly after a delay
    
      // Animate the heading with a smooth scaling effect to celebrate the countdown end
      gsap.to(".heading", {
        duration: 1.5,
        scale: 1.4,
        repeat: 3,
        yoyo: true,
        ease: "elastic.out(1, 0.3)"
      });
    }
  }, 1000);
}
