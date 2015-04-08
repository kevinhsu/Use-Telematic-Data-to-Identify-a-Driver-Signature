/**
 * @version    1.1
 * @package    Corsa
 * @author     WooRockets Team <support@woorockets.com>
 * @copyright  Copyright (C) 2014 WooRockets.com. All Rights Reserved.
 * @license    GNU/GPL v2 or later http://www.gnu.org/licenses/gpl-2.0.html
 *
 * Websites: http://www.woorockets.com
 */

(function($) {
	"use strict";
	$(document).ready(function() {

		/*  [ Detecting Mobile Devices ]
		- - - - - - - - - - - - - - - - - - - - */
		var isMobile = {
			Android: function() {
				return navigator.userAgent.match(/Android/i);
			},
			BlackBerry: function() {
				return navigator.userAgent.match(/BlackBerry/i);
			},
			iOS: function() {
				return navigator.userAgent.match(/iPhone|iPad|iPod/i);
			},
			Opera: function() {
				return navigator.userAgent.match(/Opera Mini/i);
			},
			Windows: function() {
				return navigator.userAgent.match(/IEMobile/i) || navigator.userAgent.match(/WPDesktop/i);
			},
			Desktop: function() {
				return window.innerWidth <= 960;
			},
			any: function() {
				return ( isMobile.Android() || isMobile.BlackBerry() || isMobile.iOS() || isMobile.Opera() || isMobile.Windows() || isMobile.Desktop() );
			}
		};

		/*  [ Custom RTL Menu ]
		- - - - - - - - - - - - - - - - - - - - */
		if ( ! isMobile.any() ) {
			$( '.sub-menu li' ).on( 'hover', function () {
			var sub_menu = $( this ).find( ' > .sub-menu' );
				if ( sub_menu.length ) {
					if ( sub_menu.outerWidth() > ( $( window ).outerWidth() - sub_menu.offset().left ) ) {
						$( this ).addClass( 'menu-rtl' );
					}
				}
			});
		}

		/*  [ Back To Top ]
		- - - - - - - - - - - - - - - - - - - - */
		$(window).scroll(function () {
			if ( $( this ).scrollTop() > 50 ) {
				$( '.back-to-top' ).fadeIn( 'slow' );
			} else {
				$( '.back-to-top' ).fadeOut( 'slow' );
			}
		});
		$('.back-to-top').click(function () {
			$( "html, body" ).animate({
				scrollTop: 0
			}, 500);
			return false;
		});

		/*  [ Search Box ]
		- - - - - - - - - - - - - - - - - - - - */
		$( '.search-box .search-form' ).hide();
		$( '.search-box i' ).click(function(e) {
			e.stopPropagation();
			var search_form = $( this ).parent().find( '.search-form' );

			if ( search_form.css( 'display' ) == 'block' ) {
				search_form.hide();
			} else {
				search_form.show();
			}
		});

		/*  [ Menu Responsive ]
		- - - - - - - - - - - - - - - - - - - - */
		if ( isMobile.any() ) {
			var container, button, menu;
			container = document.getElementById( 'site-navigation' );
			if ( ! container )
				return;

			button = container.getElementsByTagName( 'button' )[0];
			if ( 'undefined' === typeof button )
				return;

			menu = container.getElementsByTagName( 'ul' )[0];

			// Hide menu toggle button if menu is empty and return early.
			if ( 'undefined' === typeof menu ) {
				button.style.display = 'none';
				return;
			}

			button.onclick = function() {
				if ( -1 !== container.className.indexOf( 'active' ) )
					container.className = container.className.replace( ' active', '' );
				else
					container.className += ' active';
			};

			var MenuChildren = $('#menu-main .menu-item-has-children');

			MenuChildren.children('a').after('<i class="dashicons dashicons-arrow-down"></i>');
			MenuChildren.on('click', '.dashicons', function(e){
				e.stopPropagation();
				$(this).parent('.menu-item').toggleClass('active');
			});
		}

		/*  [ Remove p empty tag of page builder ]
		- - - - - - - - - - - - - - - - - - - - */
		$( 'p' ).each(function() {
			var $this = $( this );
				if( $this.html().replace(/\s|&nbsp;/g, '').length == 0) {
				$this.remove();
			}
		});


		/*  [ Modify default gallery of wordpress to carousel ]
		- - - - - - - - - - - - - - - - - - - - - - - - - - - - */
		$( ".gallery" ) .owlCarousel({
			items: 1,
			pagination: true,
		});

	});
})(jQuery);