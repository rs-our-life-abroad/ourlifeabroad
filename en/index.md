---
layout: default
lang: en
title: Home
permalink: /en/
---

<div class="home-intro">
  <h1>Welcome to Our Life Abroad 🌍</h1>
  
  <p>We're <strong>Romain and Steph</strong>, a French couple who ditched the 9-to-5 to live differently.</p>
  
  <p><strong>Our philosophy: slow travel</strong><br>
  No rushing, no tourist checklists. We settle in each city for 1-2 months to live like locals.</p>
</div>

---

## 📍 Our journey

<div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(250px, 1fr)); gap: 2rem; margin: 2rem 0;">
  
  <div style="text-align: center; padding: 1.5rem; background: white; border: 2px solid var(--ink-dark); border-radius: 8px; transform: rotate(-1deg);">
    <div style="font-size: 3rem; margin-bottom: 0.5rem;">🌏</div>
    <h3 style="font-family: 'Caveat', cursive; font-size: 1.8rem;">Asia</h3>
    <p>Bali, Vietnam, Thailand, Philippines</p>
  </div>
  
  <div style="text-align: center; padding: 1.5rem; background: white; border: 2px solid var(--ink-dark); border-radius: 8px; transform: rotate(1deg);">
    <div style="font-size: 3rem; margin-bottom: 0.5rem;">🦘</div>
    <h3 style="font-family: 'Caveat', cursive; font-size: 1.8rem;">Oceania</h3>
    <p>8 years in Australia</p>
  </div>
  
  <div style="text-align: center; padding: 1.5rem; background: white; border: 2px solid var(--ink-dark); border-radius: 8px; transform: rotate(-1deg);">
    <div style="font-size: 3rem; margin-bottom: 0.5rem;">🌎</div>
    <h3 style="font-family: 'Caveat', cursive; font-size: 1.8rem;">South America</h3>
    <p>Salta, Asunción, Lima, Arequipa...</p>
  </div>
  
</div>

---

## 📝 Latest Posts

<div class="posts-list">

{% assign posts_en = site.posts | where: "lang", "en" %}
{% for post in posts_en limit:5 %}
  <div class="post-card">
    <h3><a href="{{ post.url | relative_url }}">{{ post.title }}</a></h3>
    <div class="post-meta">
      {{ post.date | date: "%d/%m/%Y" }} • By {{ site.authors[post.author].name }}
    </div>
    <p>{{ post.excerpt | strip_html | truncate: 200 }}</p>
    <a href="{{ post.url | relative_url }}" class="read-more">Read more →</a>
  </div>
{% endfor %}

</div>

---

## 🎯 On this blog, we share:

- 💰 **Real budgets** (rent, food, transport)
- 📱 Our **nomad setup** (tested gear only)
- 🏠 **Accommodation hacks** and practical tips
- 📸 **Unfiltered photos** of our daily life
- 🎬 **Vlogs** from our days

**No BS, just real nomad life.**