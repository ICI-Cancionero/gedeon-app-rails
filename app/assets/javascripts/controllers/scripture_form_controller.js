class ScriptureFormController extends Stimulus.Controller {
  static targets = [
    'bibleVersion',
    'book',
    'chapterNum',
    'verses',
    'content',
    'from',
    'to'
  ]

  connect() {
    console.log("ScriptureForm attached");

    this.oldFrom = this.fromTarget.value;
    this.oldTo = this.toTarget.value;

    $(this.bibleVersionTarget).on('select2:select', function () {
      let event = new Event('change', { bubbles: true }) // fire a native event
      this.dispatchEvent(event);
    });

    $(this.bookTarget).on('select2:select', function () {
      let event = new Event('change', { bubbles: true }) // fire a native event
      this.dispatchEvent(event);
    });

    $(this.chapterNumTarget).on('select2:select', function () {
      let event = new Event('change', { bubbles: true }) // fire a native event
      this.dispatchEvent(event);
    });

    if (this.bookTarget.value.length > 0 && this.chapterNumTarget.value.length > 0){
      this.handleChapterNumChange();
    }
  }

  async handleBibleChange(event){
    console.log(this.bibleVersionTarget.value);

    const response = await fetch(`/admin/scriptures/books?bible_version=${this.bibleVersionTarget.value}`);
    const data = await response.json();

    const select2 = $(this.bookTarget);
    // Clear existing options
    select2.empty();

    // empty option
    const option = new Option("", "", false, false);
    select2.append(option);

    // Add new options
    data.forEach(item => {
      const option = new Option(`${item.book_title}`, item.book_title, false, false);
      select2.append(option);
    });

    // Trigger change event to refresh Select2
    select2.trigger('change');

    $(this.chapterNumTarget).empty();
    $(this.fromTarget).empty();
    $(this.toTarget).empty();
    this.contentTarget.value = "";
  }

  async handleBookChange(event){
    console.log(this.bookTarget.value);

    const response = await fetch(`/admin/scriptures/chapters?bible_version=${this.bibleVersionTarget.value}&book_id=${this.bookTarget.value}`);
    const data = await response.json();

    const select2 = $(this.chapterNumTarget);
    // Clear existing options
    select2.empty();

    // empty option
    const option = new Option("", "", false, false);
    select2.append(option);

    // Add new options
    data.forEach(item => {
      const option = new Option(`${item.book_title} #${item.chapter_num}`, item.chapter_num, false, false);
      select2.append(option);
    });

    // Trigger change event to refresh Select2
    select2.trigger('change');
  }

  async handleChapterNumChange(event) {
    const response = await fetch(`/admin/scriptures/verses?bible_version=${this.bibleVersionTarget.value}&book_id=${this.bookTarget.value}&chapter_num=${this.chapterNumTarget.value}`);
    this.versesData = await response.json();

    // Filling From Select with verses
    let select2 = $(this.fromTarget);
    select2.empty();

    // empty option
    let option = new Option("", "", false, false);
    select2.append(option);

    // Add new options
    this.versesData.forEach(item => {
      let option = new Option(item.num, item.num, false, false);
      select2.append(option);
    });

    select2.trigger('change');

    // Filling To Select with verses
    select2 = $(this.toTarget);
    select2.empty();

    // empty option
    option = new Option("", "", false, false);
    select2.append(option);

    // Add new options
    this.versesData.forEach(item => {
      let option = new Option(item.num, item.num, false, false);
      select2.append(option);
    });

    select2.trigger('change');

    if (this.oldFrom.length > 0){
      this.fromTarget.value = this.oldFrom;
    }

    if (this.oldTo.length > 0){
      this.toTarget.value = this.oldTo;
    }

  }

  handleSearchScriptureClick(event) {
    event.preventDefault();
    event.stopPropagation();
    event.stopImmediatePropagation();

    if (this.fromTarget.value.length == 0 || (this.fromTarget.value.length == 0 && this.toTarget.value.length == 0)) {
      alert("You must select the versicles");
      this.contentTarget.value = "";
    } else {
      let from = parseInt(this.fromTarget.value);
      let to = parseInt(this.toTarget.value) || from;

      if (from > to) {
        alert("From must be less than To");
        this.contentTarget.value = "";
      } else {
        let selectedContent = this.versesData.reduce((acc, verse) => {
          if (verse.num >= from && verse.num <= to) {
            return `${acc} ${verse.num}. ${verse.text}\n`
          } else {
            return acc;
          }
        }, '');

        this.contentTarget.value = selectedContent
      }
    }
  }
}