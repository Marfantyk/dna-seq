  function scrollTrigger(selector, options){
    let els = document.querySelectorAll(selector)
    els = Array.from(els)
    els.forEach(el => {
      addObserver(el, options)
    })
  }


  function addObserver(el, options){
      // We are creating a new IntersectionObserver instance
      let observer = new IntersectionObserver((entries, options) => { // This takes a callback function that receives two arguments: the elements list and the observer instance.
        entries.forEach(entry => {
          // `entry.isIntersecting` will be true if the element is visible
        if(entry.isIntersecting) {
          entry.target.classList.add('square-animation')
          // We are removing the observer from the element after adding the active class
          observer.unobserve(entry.target)
        }
      })
    })
    // Adding the observer to the element
    observer.observe(el)
  }

  let options = {
    root: document.querySelectorAll('sections-wrapper'),
    rootMargin: '40%',
    threshold: 1.0,
  }

  // Example usage
  scrollTrigger('.sections', options)

