const titles = document.querySelectorAll('#title')
console.log(title)
const audios = document.querySelectorAll('#audio')


const loadSong = () => {
  titles.forEach((title, index) => {
    title.addEventListener('click', (e) => {
      audios[index].classList.toggle("d-none");
    });
  });
}

export {loadSong}
