class ScriptureFormController extends Stimulus.Controller {
  static targets = [
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

    // $(this.versesTarget).on('select2:select', function () {
    //   let event = new Event('change', { bubbles: true }) // fire a native event
    //   this.dispatchEvent(event);
    // });

    // $(this.versesTarget).on('select2:unselect', function() {
    //   let event = new Event('change', { bubbles: true }) // fire a native event
    //   this.dispatchEvent(event);
    // });
  }

  // bookTargetConnected(element) {
  //   console.log("Book Target connected");

  //   $(this.bookTarget).on('select2:select', function () {
  //     let event = new Event('change', { bubbles: true }) // fire a native event
  //     this.dispatchEvent(event);
  //   });
  // }

  // chapterNumTargetConnected(element) {
  //   console.log("Chapter Target connected");

  //   $(this.chapterNumTarget).on('select2:select', function () {
  //     let event = new Event('change', { bubbles: true }) // fire a native event
  //     this.dispatchEvent(event);
  //   });
  // }

  // versesTargetConnected(element) {
  //   console.log("Verses Target connected");

  //   $(this.versesTarget).on('select2:select', function () {
  //     let event = new Event('change', { bubbles: true }) // fire a native event
  //     this.dispatchEvent(event);
  //   });

  //   $(this.versesTarget).on('select2:unselect', function() {
  //     let event = new Event('change', { bubbles: true }) // fire a native event
  //     this.dispatchEvent(event);
  //   });
  // }

  // contentTargetConnected(element) {
  //   console.log("Content Target connected");
  // }

  async handleBookChange(element){
    console.log(this.bookTarget.value);

    const response = await fetch(`/admin/scriptures/chapters?book_id=${this.bookTarget.value}`);
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

  async handleChapterNumChange(element) {
    const response = await fetch(`/admin/scriptures/verses?book_id=${this.bookTarget.value}&chapter_num=${this.chapterNumTarget.value}`);
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