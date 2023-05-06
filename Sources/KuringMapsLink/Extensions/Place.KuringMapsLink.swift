//
//  Place.KuringMapsLink.swift
//  
//
//  Created by Jaesung Lee on 2023/05/03.
//

import Foundation

extension Place {
    // places searchable
    public static var places: [Place] {
        get {
            [
                Place(id: "KU스포츠광장", name: "KU스포츠광장", category: "체육시설", address: "서울특별시 광진구 능동로 120", inCampus: true, number: nil, iconUrl: nil, latitude: 37.544361, longitude: 127.078199, phone: nil, data: nil, places: [:], parentId: "konkuk"),
                Place(id: "건대항쟁기립상", name: "건대항쟁기립상", category: "랜드마크", address: "서울시 광진구 화양동 1", inCampus: true, number: nil, iconUrl: nil, latitude: 37.54382, longitude: 127.076423, phone: nil, data: nil, places: [:], parentId: "konkuk"),
                Place(id: "청심대", name: "청심대", category: "랜드마크", address: "서울시 광진구 화양동 1", inCampus: true, number: nil, iconUrl: nil, latitude: 37.5424, longitude: 127.076823, phone: nil, data: nil, places: [:], parentId: "konkuk"),
                Place(id: "와우도", name: "와우도", category: "자연", address: "서울시 광진구 화양동 1", inCampus: true, number: nil, iconUrl: nil, latitude: 37.5401, longitude: 127.0766, phone: nil, data: nil, places: [:], parentId: "konkuk"),
                Place(id: "제2황소상", name: "제2 황소상", category: "랜드마크", address: "서울시 광진구 화양동 1", inCampus: true, number: nil, iconUrl: nil, latitude: 37.54285, longitude: 127.07735, phone: nil, data: nil, places: [:], parentId: "konkuk"),
                Place(id: "새천년관대공연장", name: "새천년관 대공연장", category: "극장", address: "서울시 광진구 화양동 1", inCampus: true, number: nil, iconUrl: nil, latitude: 37.54285, longitude: 127.07735, phone: nil, data: "http://www.weneart.com/", places: [:], parentId: "konkuk"),
                Place(id: "건축관", name: "건축관", category: "건축대학", address: "서울특별시 광진구 능동로 120", inCampus: true, number: 17, iconUrl: nil, latitude: 37.54369178, longitude: 127.0783744, phone: nil, data: nil, places: [:], parentId: "konkuk"),
                Place(id: "경영관", name: "경영관", category: "경영대학", address: "서울특별시 광진구 능동로 120", inCampus: true, number: 2, iconUrl: nil, latitude: 37.54429, longitude: 127.076112, phone: nil, data: nil, places: [:], parentId: "konkuk"),
                Place(id: "공대별관", name: "공대별관", category: "공과대학", address: "서울특별시 광진구 능동로 120", inCampus: true, number: 21, iconUrl: nil, latitude: 37.541594, longitude: 127.079365, phone: nil, data: nil, places: [:], parentId: "konkuk"),
                Place(id: "공예관", name: "공예관", category: "예술디자인대학", address: "서울특별시 광진구 능동로 120", inCampus: true, number: nil, iconUrl: nil, latitude: 37.542145, longitude: 127.081039, phone: nil, data: nil, places: [:], parentId: "konkuk"),
                Place(id: "공학관A동", name: "공학관 A동", category: "공과대학", address: "서울특별시 광진구 능동로 120", inCampus: true, number: 21, iconUrl: nil, latitude: 37.54169, longitude: 127.078808, phone: nil, data: nil, places: [:], parentId: "konkuk"),
                Place(id: "공학관B동", name: "공학관 B동", category: "공과대학", address: "서울특별시 광진구 능동로 120", inCampus: true, number: 21, iconUrl: nil, latitude: 37.542025, longitude: 127.079625, phone: nil, data: nil, places: [:], parentId: "konkuk"),
                Place(id: "공학관C동", name: "공학관 C동", category: "공과대학", address: "서울특별시 광진구 능동로 120", inCampus: true, number: 21, iconUrl: nil, latitude: 37.54118, longitude: 127.079535, phone: nil, data: nil, places: [:], parentId: "konkuk"),
                Place(id: "과학관", name: "과학관", category: "이과대학", address: "서울특별시 광진구 능동로 120", inCampus: true, number: 23, iconUrl: nil, latitude: 37.54158, longitude: 127.080604, phone: nil, data: nil, places: [:], parentId: "konkuk"),
                Place(id: "교육과학관", name: "교육과학관", category: "사범대학", address: "서울특별시 광진구 능동로 120", inCampus: true, number: 4, iconUrl: nil, latitude: 37.544046, longitude: 127.074111, phone: nil, data: nil, places: [:], parentId: "konkuk"),
                Place(id: "국제학사", name: "국제학사", category: "기숙사", address: "서울특별시 광진구 능동로 120", inCampus: true, number: 25, iconUrl: nil, latitude: 37.539819, longitude: 127.07731, phone: nil, data: nil, places: [:], parentId: "konkuk"),
                Place(id: "노천극장", name: "노천극장", category: "극장", address: "서울특별시 광진구 화양동 능동로 120", inCampus: true, number: nil, iconUrl: nil, latitude: 37.541501, longitude: 127.077815, phone: nil, data: nil, places: [:], parentId: "konkuk"),
                Place(id: "동물생명과학관", name: "동물생명과학관", category: "동물생명과학", address: "서울특별시 광진구 능동로 120", inCampus: true, number: 12, iconUrl: nil, latitude: 37.540327, longitude: 127.074379, phone: nil, data: nil, places: ["카페": ["동생대레스티오"]], parentId: "konkuk"),
                Place(id: "박물관", name: "박물관", category: "랜드마크", address: "서울특별시 광진구 능동로 120", inCampus: true, number: 7, iconUrl: "area.museum.light", latitude: 37.54236, longitude: 127.07558, phone: nil, data: nil, places: [:], parentId: "konkuk"),
                Place(id: "법학관", name: "법학관 (종강)", category: "법학전문대학원", address: "서울특별시 광진구 능동로 120", inCampus: true, number: 8, iconUrl: nil, latitude: 37.54172, longitude: 127.074831, phone: nil, data: nil, places: [:], parentId: "konkuk"),
                Place(id: "산학협동관", name: "산학협동관", category: "", address: "서울특별시 광진구 능동로 120", inCampus: true, number: 14, iconUrl: nil, latitude: 37.539673, longitude: 127.07318, phone: nil, data: nil, places: [:], parentId: "konkuk"),
                Place(id: "상허기념도서관", name: "상허기념도서관", category: "도서관", address: "서울특별시 광진구 능동로 120", inCampus: true, number: 9, iconUrl: "area.library.light", latitude: 37.54209, longitude: 127.07382, phone: nil, data: nil, places: ["식당": ["상허마루"], "휴게실": ["상허쉼터"], "카페": ["도서관레스티오"]], parentId: "konkuk"),
                Place(id: "상허연구관", name: "상허연구관", category: "", address: "서울특별시 광진구 능동로 120", inCampus: true, number: 3, iconUrl: nil, latitude: 37.543986, longitude: 127.075273, phone: nil, data: nil, places: [:], parentId: "konkuk"),
                Place(id: "상허유석창박사동상", name: "상허 유석창 박사 동상", category: "랜드마크", address: "서울시 광진구 화양동 1", inCampus: true, number: nil, iconUrl: nil, latitude: 37.541369, longitude: 127.07348, phone: nil, data: nil, places: [:], parentId: "konkuk"),
                Place(id: "새천년관", name: "새천년관", category: "", address: "서울특별시 광진구 능동로 120", inCampus: true, number: 16, iconUrl: "area.newmilli.light", latitude: 37.543583, longitude: 127.077467, phone: nil, data: nil, places: [:], parentId: "konkuk"),
                Place(id: "생명과학관", name: "생명과학관", category: "생명과학", address: "서울특별시 광진구 능동로 120", inCampus: true, number: 11, iconUrl: nil, latitude: 37.541054, longitude: 127.074463, phone: nil, data: nil, places: [:], parentId: "konkuk"),
                Place(id: "수의학관", name: "수의학관", category: "수의과대학", address: "서울특별시 광진구 능동로 120", inCampus: true, number: 15, iconUrl: nil, latitude: 37.539246, longitude: 127.074725, phone: nil, data: nil, places: [:], parentId: "konkuk"),
                Place(id: "신공학관", name: "신공학관", category: "공과대학", address: "서울특별시 광진구 능동로 120", inCampus: true, number: 22, iconUrl: nil, latitude: 37.54055, longitude: 127.079335, phone: nil, data: nil, places: [:], parentId: "konkuk"),
                Place(id: "실내체육관", name: "실내체육관", category: "체육시설", address: "서울특별시 광진구 능동로 120", inCampus: true, number: nil, iconUrl: nil, latitude: 37.544466, longitude: 127.07978, phone: nil, data: nil, places: [:], parentId: "konkuk"),
                Place(id: "언어교육원", name: "언어교육원", category: "", address: "서울특별시 광진구 능동로 120", inCampus: true, number: 6, iconUrl: "area.language.light", latitude: 37.542532, longitude: 127.074653, phone: nil, data: nil, places: [:], parentId: "konkuk"),
                Place(id: "예술문화관", name: "예술문화관", category: "예술디자인대학", address: "서울특별시 광진구 능동로 120", inCampus: true, number: 5, iconUrl: nil, latitude: 37.542913, longitude: 127.072917, phone: nil, data: nil, places: [:], parentId: "konkuk"),
                Place(id: "의생명과학연구관", name: "의생명과학연구관", category: "의학전문대학원", address: "서울특별시 광진구 능동로 120", inCampus: true, number: 10, iconUrl: nil, latitude: 37.541411, longitude: 127.072308, phone: nil, data: nil, places: [:], parentId: "konkuk"),
                Place(id: "인문학관", name: "인문학관", category: "인문대학", address: "서울특별시 광진구 능동로 120", inCampus: true, number: 19, iconUrl: nil, latitude: 37.542557, longitude: 127.078302, phone: nil, data: nil, places: [:], parentId: "konkuk"),
                Place(id: "일감호", name: "일감호", category: "랜드마크", address: "서울특별시 광진구 능동로 120", inCampus: true, number: nil, iconUrl: nil, latitude: 37.540744, longitude: 127.076451, phone: nil, data: nil, places: ["랜드마크": ["와우도", "홍예교", "청심대"]], parentId: "konkuk"),
                Place(id: "일우헌", name: "일우헌", category: "기숙사", address: "서울특별시 광진구 능동로 120", inCampus: true, number: nil, iconUrl: nil, latitude: 37.544856, longitude: 127.079519, phone: nil, data: nil, places: [:], parentId: "konkuk"),
                Place(id: "입학정보관", name: "입학정보관", category: "", address: "서울특별시 광진구 능동로 120", inCampus: true, number: 13, iconUrl: nil, latitude: 37.540352, longitude: 127.073489, phone: nil, data: nil, places: [:], parentId: "konkuk"),
                Place(id: "제2학생회관", name: "제2 학생회관", category: "", address: "서울특별시 광진구 능동로 120", inCampus: true, number: nil, iconUrl: nil, latitude: 37.541172, longitude: 127.077961, phone: nil, data: nil, places: ["공연": ["노천극장"]], parentId: "konkuk"),
                Place(id: "중장비실험동", name: "중장비실험동", category: "공과대학", address: "서울특별시 광진구 능동로 120", inCampus: true, number: 21, iconUrl: nil, latitude: 37.542356, longitude: 127.079973, phone: nil, data: nil, places: [:], parentId: "konkuk"),
                Place(id: "창의관", name: "창의관", category: "", address: "서울특별시 광진구 능동로 120", inCampus: true, number: 24, iconUrl: nil, latitude: 37.541237, longitude: 127.081686, phone: nil, data: "113 학군단", places: [:], parentId: "konkuk"),
                Place(id: "쿨하우스글로벌홀", name: "쿨하우스 글로벌홀", category: "기숙사", address: "서울특별시 광진구 능동로 120", inCampus: true, number: 26, iconUrl: nil, latitude: 37.5391, longitude: 127.078714, phone: nil, data: nil, places: [:], parentId: "konkuk"),
                Place(id: "쿨하우스드림홀", name: "쿨하우스 드림홀", category: "기숙사", address: "서울특별시 광진구 능동로 120", inCampus: true, number: 26, iconUrl: nil, latitude: 37.539, longitude: 127.079427, phone: nil, data: nil, places: [:], parentId: "konkuk"),
                Place(id: "쿨하우스레이크홀", name: "쿨하우스 레이크홀", category: "기숙사", address: "서울특별시 광진구 능동로 120", inCampus: true, number: 26, iconUrl: nil, latitude: 37.539424, longitude: 127.077196, phone: nil, data: nil, places: [:], parentId: "konkuk"),
                Place(id: "쿨하우스비전홀", name: "쿨하우스 비전홀", category: "기숙사", address: "서울특별시 광진구 능동로 120", inCampus: true, number: 26, iconUrl: nil, latitude: 37.539491, longitude: 127.078153, phone: nil, data: nil, places: [:], parentId: "konkuk"),
                Place(id: "쿨하우스프론티어홀", name: "쿨하우스 프론티어홀", category: "기숙사", address: "서울특별시 광진구 능동로 120", inCampus: true, number: 26, iconUrl: nil, latitude: 37.539601, longitude: 127.078978, phone: nil, data: nil, places: [:], parentId: "konkuk"),
                Place(id: "학생회관", name: "학생회관", category: "건국대학교", address: "서울특별시 광진구 능동로 120", inCampus: true, number: 20, iconUrl: "area.museum.light", latitude: 37.541875, longitude: 127.077966, phone: nil, data: nil, places: [:], parentId: "konkuk"),
                Place(id: "해봉부동산학관", name: "해봉부동산학관", category: "부동산대학", address: "서울특별시 광진구 능동로 120", inCampus: true, number: 18, iconUrl: nil, latitude: 37.543421, longitude: 127.078252, phone: nil, data: nil, places: [:], parentId: "konkuk"),
                Place(id: "행정관", name: "행정관", category: "", address: "서울특별시 광진구 능동로 120", inCampus: true, number: 1, iconUrl: nil, latitude: 37.543141, longitude: 127.075144, phone: nil, data: nil, places: [:], parentId: "konkuk")
            ]
        }
    }
//    static var places: [Place] {
//        get throws {
//            if let path = Bundle.link.path(forResource: "place", ofType: "json") {
//                let data = try Data(contentsOf: URL(fileURLWithPath: path, parentId: "konkuk"), options: .mappedIfSafe)
//                return try JSONDecoder().decode([Place].self, from: data)
//            } else {
//                return []
//            }
//        }
//    }
}
