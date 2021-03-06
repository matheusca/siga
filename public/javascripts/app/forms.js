 // Limpa os campos de busca
 $.fn.clearClick = function() {
     return this.focus(function() {
         if( this.value == this.defaultValue ) {
             this.value = "";
         }
     }).blur(function() {
         if( !this.value.length ) {
             this.value = this.defaultValue;
         }
     });
 };

 /**
 * Set grid table in list
 */
 $(document).ready(function () {

     $("#search").clearClick();
     $(".calendar").datepicker();
     $(".money").priceFormat({
    prefix: '',
    centsSeparator: ',',
    thousandsSeparator: '.'
});
 });
