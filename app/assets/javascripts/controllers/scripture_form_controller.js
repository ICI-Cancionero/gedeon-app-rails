class ScriptureFormController extends Stimulus.Controller {
  static targets = [
    'book',
    'chapterNum',
    'verses',
    'content'
  ]

  connect() {
    console.log("ScriptureForm attached");

    $(this.bookTarget).on('select2:select', function () {
      let event = new Event('change', { bubbles: true }) // fire a native event
      this.dispatchEvent(event);
    });

    $(this.chapterNumTarget).on('select2:select', function () {
      let event = new Event('change', { bubbles: true }) // fire a native event
      this.dispatchEvent(event);
    });

    $(this.versesTarget).on('select2:select', function () {
      let event = new Event('change', { bubbles: true }) // fire a native event
      this.dispatchEvent(event);
    });

    $(this.versesTarget).on('select2:unselect', function() {
      let event = new Event('change', { bubbles: true }) // fire a native event
      this.dispatchEvent(event);
    });
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

    const select2 = $(this.versesTarget);
    // Clear existing options
    select2.empty();

    // empty option
    const option = new Option("", "", false, false);
    select2.append(option);

    // Add new options
    this.versesData.forEach(item => {
      const option = new Option(item.num, item.num, false, false);
      select2.append(option);
    });

    // Trigger change event to refresh Select2
    select2.trigger('change');
  }

  async handleVersesChange(element) {
    var content = this.contentTarget.value;

    var selectedVerseNums = Array.from(this.versesTarget.selectedOptions).map((option) => {
      return parseInt(option.value)
    });

    var selectedVerses = this.versesData.filter((verse) => {
      return selectedVerseNums.includes(verse.num)
    });

    var selectedContent = selectedVerses.reduce((acc, verse) => {
      return `${acc} ${verse.num}. ${verse.text}`
    }, '');

    this.contentTarget.value = selectedContent
  }
}