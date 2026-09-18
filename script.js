document.addEventListener("DOMContentLoaded", function () {
    const menuIcon = document.querySelector(".menu-icon");
    const navLinks = document.querySelector(".nav-links");

    // Lắng nghe sự kiện click vào biểu tượng hamburger menu
    menuIcon.addEventListener("click", function () {
        navLinks.classList.toggle("active");
    });
});