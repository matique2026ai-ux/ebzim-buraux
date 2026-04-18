export declare class CreateLeaderDto {
    name: {
        ar: string;
        en: string;
        fr: string;
    };
    role: {
        ar: string;
        en: string;
        fr: string;
    };
    photoUrl?: string;
    order?: number;
    isActive?: boolean;
}
export declare class UpdateLeaderDto extends CreateLeaderDto {
}
