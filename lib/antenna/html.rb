require 'erb'

module Antenna
  class HTML
    include ERB::Util
  
    attr_accessor :info_plist, :manifest_url, :display_image_url, :need_shine, :file_last_modified

    def initialize(info_plist, manifest_url, display_image_url, file_last_modified_date)
        @info_plist, @manifest_url, @display_image_url = info_plist, manifest_url, display_image_url, @file_last_modified = file_last_modified_date
    end

    def template
      <<-EOF
<!doctype html>
<html>

<head>
    <title><%= @info_plist.bundle_display_name %> v<%= @info_plist.bundle_short_version %>
        (<%= @info_plist.bundle_version %>)</title>
    <meta name="viewport" content="initial-scale=1.0, user-scalable=no">
    <style type="text/css">
        body {
            font-family: Helvetica, Arial, sans-serif;
            text-align: center;
            color: #444;
            font-size: 18px;
        }

        img {
            display: block;
            margin: 1em auto;
            border: none;
            width: 120px;
            height: 120px;
            border-radius: 20px;
        }

        .btn,
        a.btn,
        a.btn:visited,
        a.btn:hover,
        a.btn:link {
            display: inline-block;
            border-radius: 3px;
            background-color: #0095c8;
            color: white;
            padding: .8em 1em;
            text-decoration: none;
        }

        a.btn:hover {
            background-color: #00bbfb;
            color: white;
        }

        p {
            color: #999
        }

        a:link {
            color: #6CF;
            text-decoration: none;
            font-size: 14px;
        }

        a:visited {
            color: #39C;
            text-decoration: none;
        }

        #title,
        #title a:link,
        #title a:visited {
            color: #FFFFFF;
        }

        #content {
            height: auto;
            width: auto;
            margin-right: auto;
            margin-left: auto;
            text-align: center;
            vertical-align: top;
        }

        #centered {
            position: fixed;
            top: 50%;
            left: 50%;
            margin-top: -120px;
            margin-left: -100px;
        }

        #radius-ios {
            border: 2px solid black;
            -moz-border-radius: 25px;
            -webkit-border-radius: 25px;
            border-radius: 25px;
        }

        #overlay {
            position: fixed;
            display: none;
            width: 100%;
            height: 100%;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background-color: rgba(0, 0, 0, 0.8);
            z-index: 2;
            cursor: pointer;
        }

        #text {
            position: absolute;
            top: 50%;
            left: 50%;
            font-size: 16px;
            color: white;
            margin-right: -30%;
            transform: translate(-50%, -50%);
        }
    </style>
    <script
        type="text/javascript"> function on() { document.getElementById("overlay").style.display = "block"; } function off() { document.getElementById("overlay").style.display = "none"; } window.onload = function () { var observed = document.getElementsByTagName('a'); var overlay = document.getElementById("overlay"); for (var i = 0; i < observed.length; i++) { observed[i].addEventListener('click', function (e) { if (overlay.style.display === "block") { overlay.style.display = "none"; } else { overlay.style.display = "block"; } e.returnValue = true; }, false); } } </script>
</head>
<div id="overlay" onclick="off()">
    <div id="text">
        <center>Please confirm the installation dialog, then press your Home button to see the installation
            progress. Note that the app's icon might appear on any of your home screens.</center>
    </div>
</div>
<div id="content">
    <body>
        <h1><%= @info_plist.bundle_display_name %></h1>
        <h2><%= @info_plist.bundle_short_version %> (<%= @info_plist.bundle_version %>)</h2>
        <h2><%= @file_last_modified %></h1>
            <% if @display_image_url %>
            <a href="itms-services://?action=download-manifest&amp;url=<%= u(@manifest_url) %>">
            <img src="https://apps.dnanudge.io/app.png">
            <!-- <img src="<%= @display_image_url %>"> -->
            </a>
            <% end %>
            <a href="itms-services://?action=download-manifest&amp;url=<%= u(@manifest_url) %>" class="btn">Tap to
                install</a>
            <% if @info_plist.bundle_minimum_os_version %>
            <p class="comment">
                This app requires iOS <%= @info_plist.bundle_minimum_os_version %> or higher.
            </p>
            <% end %>
    </body>
</div>

</html>
EOF
    end

    def to_s
      ERB.new(template).result(binding)
    end
  end
end