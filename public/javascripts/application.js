// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
$(function() {
  var trackEvent = function(category, action, label, value) {

    if (! category) { throw new Error("ArgumentError: category required"); }
    if (! category) { throw new Error("ArgumentError: action requried."); }
    if (value && !isFinite(value)) { throw new Error("ArgumentError: value must be a number."); }

    if (window.ga) {

      var args = ["send", "event", category, action];
      if (label) { args.push(label); }
      if (value) { args.push(value); }

      ga.apply(window, args);
    }
  };

  $(document).on('click', '[data-category]', function(e) {
    var category = $(this).data('category') || "clicks";
    var action   = $(this).data("action") || "clicked";
    var label    = $(this).data("label") || null;
    var value    = $(this).data("value") || null;

    trackEvent(category, action, label, value);
  });

  $(document).on('click', 'ul.pagination a', function(e) {

    var $parent = $(this).parent();
    if ($parent.hasClass("previous_page")) {
      action = "previous";
    } else if($parent.hasClass("next_page")) {
      action = "next";
    } else {
      action = $(this).text();
    }

    trackEvent("Pagination", action);
  });

});
