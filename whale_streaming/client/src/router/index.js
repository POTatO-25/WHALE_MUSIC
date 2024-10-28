import { createMemoryHistory, createRouter } from 'vue-router';

import MainRecommendation from '../components/main/MainRecommendation.vue';
import MainSearchHome from '../components/main/MainSearchHome.vue';
import MainSearch from '../components/main/MainSearch.vue';
import MainDetailArtist from '../components/main/MainDetailArtist.vue';
import MainDetailAlbum from '../components/main/MainDetailAlbum.vue';
import MainPlaylist from '../components/main/MainPlaylist.vue';

const routes = [
    { path: '/whale/streaming/recommend', component: MainRecommendation },
    { path: '/whale/streaming/searchHome', component: MainSearchHome },
    { path: '/whale/streaming/search/:query', component: MainSearch },
    { path: '/whale/streaming/detail/artist', component: MainDetailArtist },
    { path: '/whale/streaming/detail/album', component: MainDetailAlbum },
    { path: '/whale/streaming/playlist', component: MainPlaylist },
];

const router = createRouter({
    history: createMemoryHistory(),
    routes,
});

export default router;