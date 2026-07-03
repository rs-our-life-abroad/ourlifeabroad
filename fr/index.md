---
layout: default
lang: fr
title: Accueil
permalink: /fr/
---

<div class="home-intro">
  <h1>Bienvenue sur Notre Vie à l'Étranger 🌍</h1>
  
  <p>Nous sommes <strong>Romain et Steph</strong>, un couple français qui a quitté la routine métro-boulot-dodo pour vivre autrement.</p>
  
  <p><strong>Notre philosophie : le slow travel</strong><br>
  Pas de rush, pas de checklist touristique. On s'installe 1 à 2 mois par ville pour vivre comme des locaux.</p>
</div>

---

## 📍 Notre parcours

<div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(250px, 1fr)); gap: 2rem; margin: 2rem 0;">

  <a href="/fr/destinations/asie/" style="text-decoration: none; color: inherit;">
    <div style="text-align: center; padding: 1.5rem; background: white; border: 2px solid var(--ink-dark); border-radius: 8px; transform: rotate(-1deg); transition: transform 0.3s; cursor: pointer;">
      <div style="font-size: 3rem; margin-bottom: 0.5rem;">🌏</div>
      <h3 style="font-family: 'Caveat', cursive; font-size: 1.8rem;">Asie</h3>
      <p>Bali, Vietnam, Thaïlande, Philippines</p>
    </div>
  </a>

  <a href="/fr/destinations/oceanie/" style="text-decoration: none; color: inherit;">
    <div style="text-align: center; padding: 1.5rem; background: white; border: 2px solid var(--ink-dark); border-radius: 8px; transform: rotate(1deg); transition: transform 0.3s; cursor: pointer;">
      <div style="font-size: 3rem; margin-bottom: 0.5rem;">🦘</div>
      <h3 style="font-family: 'Caveat', cursive; font-size: 1.8rem;">Océanie</h3>
      <p>8 ans en Australie</p>
    </div>
  </a>

  <a href="/fr/destinations/amerique-sud/" style="text-decoration: none; color: inherit;">
    <div style="text-align: center; padding: 1.5rem; background: white; border: 2px solid var(--ink-dark); border-radius: 8px; transform: rotate(-1deg); transition: transform 0.3s; cursor: pointer;">
      <div style="font-size: 3rem; margin-bottom: 0.5rem;">🌎</div>
      <h3 style="font-family: 'Caveat', cursive; font-size: 1.8rem;">Amérique du Sud</h3>
      <p>Buenos Aires, Salta, Asunción, Lima, Arequipa, Cusco...</p>
    </div>
  </a>

  <a href="/fr/destinations/europe/" style="text-decoration: none; color: inherit;">
    <div style="text-align: center; padding: 1.5rem; background: white; border: 2px solid var(--ink-dark); border-radius: 8px; transform: rotate(1deg); transition: transform 0.3s; cursor: pointer;">
      <div style="font-size: 3rem; margin-bottom: 0.5rem;">🌍</div>
      <h3 style="font-family: 'Caveat', cursive; font-size: 1.8rem;">Europe</h3>
      <p>À venir...</p>
    </div>
  </a>

</div>

---

## 📝 Derniers Articles

<div class="posts-list">

{% assign posts_fr = site.posts | where: "lang", "fr" %}
{% for post in posts_fr limit:5 %}
  <div class="post-card">
    <h3><a href="{{ post.url | relative_url }}">{{ post.title }}</a></h3>
    <div class="post-meta">
      {{ post.date | date: "%d/%m/%Y" }} • Par {{ site.authors[post.author].name }}
    </div>
    <p>{{ post.excerpt | strip_html | truncate: 200 }}</p>
    <a href="{{ post.url | relative_url }}" class="read-more">Lire la suite →</a>
  </div>
{% endfor %}

</div>

---

## 🎯 Sur ce blog, on partage :

- 💰 Les **vrais budgets** (loyers, bouffe, transport)
- 📱 Notre **setup nomade** (équipement testé et approuvé)
- 🏠 Nos **bons plans logement** et vie pratique
- 📸 Des **photos sans filtre** de notre quotidien
- 🎬 Des **vlogs** de nos journées

**Pas de bullshit, juste la réalité du nomadisme.**