export declare class CreateHeroSlideDto {
    title: {
        ar: string;
        en: string;
        fr: string;
    };
    subtitle: {
        ar: string;
        en: string;
        fr: string;
    };
    imageUrl: string;
    buttonText?: string;
    buttonLink?: string;
    order?: number;
    isActive?: boolean;
}
export declare class UpdateHeroSlideDto extends CreateHeroSlideDto {
}
