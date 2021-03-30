---
title: "About"
date: 2019-08-02T11:04:49+08:00
menu: main
---

<style>

    @import url('https://fonts.googleapis.com/css?family=Katibeh&display=swap');

    .about-info {
        display: flex;
        justify-content: space-between;
        align-items: flex-start;
    }

    .about-info-left li {
        list-style-type: none;
    }

    .about-info-right {
        margin: .5em 1.25em;
    }

    .about-info-right img {
        width: 130px;
    }

    .about-info-right .left-ear,
    .about-info-right .left-hand,
    .about-info-right .right-ear,
    .about-info-right .right-hand {
        display: none;
    }

    @media only screen and (min-device-width: 320px) and (max-device-width: 480px) {
        .about-info {
            flex-direction: column-reverse;
            align-items: center;
        }

        .about-info-right {
            margin: auto auto 2em;
            display: flex;
            flex-direction: row;
            justify-content: center;
            align-items: center;
        }

        .about-info-right img {
            border-radius: 50%;
            -webkit-border-radius: 50%;
        }

        .about-info-right .left-hand {
            font-family: 'Katibeh';
            display: inline;
            font-size: 5em;
            transform: translate(20px);
            -moz-transform: translate(20px);
            -webkit-transform: translate(20px);
            -o-transform: translate(20px);
        }

        .about-info-right .right-hand {
            font-family: 'Katibeh';
            display: inline;
            font-size: 5em;
            transform: translate(-18px);
            -moz-transform: translate(-18px);
            -webkit-transform: translate(-18px);
            -o-transform: translate(-18px);
        }

        .about-info-right .left-ear {
            display: inline;
            font-size: 1.2em;
            align-self: flex-start;
            transform: rotate(-40deg) translate(20px, 15px);
            -moz-transform: rotate(-40deg) translate(20px, 15px);
            -webkit-transform: rotate(-40deg) translate(20px, 15px);
            -o-transform: rotate(-40deg) translate(20px, 15px);
        }

        .about-info-right .right-ear {
            display: inline;
            font-size: 1.2em;
            align-self: flex-start;
            transform: rotate(45deg) translate(-13px, 15px);
            -moz-transform: rotate(45deg) translate(-13px, 15px);
            -webkit-transform: rotate(45deg) translate(-13px, 15px);
            -o-transform: rotate(45deg) translate(-13px, 15px);
        }
    }
</style>

<div class="about-info">
    <div class="about-info-left">
        <p>To see the world as it is and to love it.</p>
        <p>Contact me:</p>
        <ul>
	<li><p><span class="iconfont icon-mail"></span> Email: <a href="mailto:wq.lu@outlook.com"
                    rel="nofollow noreferrer" target="_blank">wq.lu@outlook.com</a></p></li>
	<li><p><span class="iconfont icon-git"></span> GitHub: <a href="https://github.com/wqlu"
                        rel="nofollow noreferrer" target="_blank">wqlu</a></p></li>
        </ul>
    </div>
    <div class="about-info-right">
	    <div class="left-hand"><span style="font-size: 0.5em">&ensp;</span>٩</div>
        <div class="left-ear">▲</div>
        <img alt="wqlu" src="/images/avatar.png">
        <div class="right-ear">▲</div>
        <div class="right-hand">و<span style="font-size: 0.5em">✧</span></div>
    </div>
</div>

<p><img src="https://ghchart.rshah.org/wqlu" alt="wqlu's Github chart" style="width: 100%;"></p>
