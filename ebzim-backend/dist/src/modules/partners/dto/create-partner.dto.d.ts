export declare class CreatePartnerDto {
    name: {
        ar: string;
        en: string;
        fr: string;
    };
    logoUrl: string;
    goalsSummary: {
        ar: string;
        en: string;
        fr: string;
    };
    websiteUrl?: string;
    color?: string;
    order?: number;
    isActive?: boolean;
}
export declare class UpdatePartnerDto extends CreatePartnerDto {
}
